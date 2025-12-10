#!/usr/local/bin/ruby -w
#
# vim:sw=2 ts=8:et sta
#
#
# Copyright (c) 2003, 2004, 2005 Ariff Abdullah 
#        (skywizard@MyBSD.org.my)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#        $MyBSD$
#
# Date: Sat Dec 20 23:07:10 MYT 2003
#   OS: FreeBSD kasumi.MyBSD.org.my 4.7-RELEASE i386
#
#  cookcd.rb(8), IDE/ATAPI cd burner entirely written using ruby.
#  Compatible with burncd (FreeBSD)
#   http://www.freebsd.org/cgi/cvsweb.cgi/src/usr.sbin/burncd
#
#  Most of the logic taken from burncd(8) itself, with few differences:
#  (including why this has been written in the first place)
#  * fix burncd broken DAO burning (audio, data/raw). Other type of
#    burning mode not tested (yet). /usr/sbin/burncd generate flaw TOC/CUE
#    resulting broken DAO cd.
#  * automatically truncate wave header if data mode is audio
#  * 10 seconds confirmation timeout before proceed simmilar with cdrecord
#    (use '-y' to supress it)
#
#  Caveat: since this is written entirely using ruby, probably it's
#          compatibility is nowhere but FreeBSD 4.x/5.x /usr/include/sys/cdio.h
#          and /usr/include/sys/cdrio.h
#  TODO: Proper machine byte ordering / endianess check
#

require 'getoptlong'

def MIN(x, y)
  x > y ? y : x
end

module IOCCOM
  PARM_MASK = 0x1fff
  VOID      = 0x20000000
  OUT       = 0x40000000
  IN        = 0x80000000
  INOUT     = IN|OUT
  DIRMASK   = 0xe0000000
  def PARM_LEN(x)
    (x >> 16) & PARM_MASK
  end
  def BASECMD(x)
    x & ~(PARM_MASK << 16)
  end
  def GROUP(x)
    (x >> 8) & 0xff
  end
  def _IOC(inout, group, num, len)
    inout | ((len & PARM_MASK) << 16) | ((group.is_a?(String) ? group[0] : group) << 8) | num
  end
  def _IO(g, n)
    _IOC(VOID, g, n, 0)
  end
  def _IOR(g, n, t)
    _IOC(OUT, g, n, t)
  end
  def _IOW(g, n, t)
    _IOC(IN, g, n, t)
  end
  def _IOWR(g, n, t)
    _IOC(INOUT, g, n, t)
  end
  module_function :PARM_LEN, :BASECMD, :GROUP
  module_function :_IOC, :_IO, :_IOR, :_IOW, :_IOWR
end

module DISK
  class << self
    include IOCCOM
  end
  DIOCGMEDIASIZE = _IOR('d', 129, 8)
end

module CDIO
  class << self
    include IOCCOM
  end
  CDIOCSTART = _IO('c', 22)
  CDIOCEJECT = _IO('c', 24)
  CDIOCCLOSE = _IO('c', 28)
  sizeof_ioc_toc_header = [0, 0, 0].pack('SC2').size()
  CDIOREADTOCHEADER = _IOR('c', 4, sizeof_ioc_toc_header)
  # XXX struct with bitfield black magic art
  sizeof_cd_toc_entry = [0, 0, 0].pack('xC2xN').size()
  sizeof_ioc_read_toc_single_entry = [0, 0].pack('C2x2').size() +
      sizeof_cd_toc_entry
  CDIOREADTOCENTRY = _IOWR('c', 6, sizeof_ioc_read_toc_single_entry)
  sizeof_ioc_read_toc_entry = [0, 0, 0, "\0"].pack('C2SP').size()
  CDIOREADTOCENTRYS = _IOWR('c', 5, sizeof_ioc_read_toc_entry)

  CD_LBA_FORMAT = 1
end

module CDRIO
  class << self
    include IOCCOM
  end
  CDR_DB_RAW          = 0x0
  CDR_DB_RAW_PQ       = 0x1
  CDR_DB_RAW_PW       = 0x2
  CDR_DB_RAW_PW_R     = 0x3
  CDR_DB_RES_4        = 0x4
  CDR_DB_RES_5        = 0x5
  CDR_DB_RES_6        = 0x6
  CDR_DB_VS_7         = 0x7
  CDR_DB_ROM_MODE1    = 0x8
  CDR_DB_ROM_MODE2    = 0x9
  CDR_DB_XA_MODE1     = 0xa
  CDR_DB_XA_MODE2_F1  = 0xb
  CDR_DB_XA_MODE2_F2  = 0xc
  CDR_DB_XA_MODE2_MIX = 0xd
  CDR_DB_RES_14       = 0xe
  CDR_DB_VS_15        = 0xf
  
  CDR_SESS_CDROM    = 0x00
  CDR_SESS_CDI      = 0x10
  CDR_SESS_CDROM_XA = 0x20
  CDR_SESS_NONE     = 0x00
  CDR_SESS_FINAL    = 0x01
  CDR_SESS_RESERVED = 0x02
  CDR_SESS_MULTI    = 0x03

  sizeof_int = [0].pack('i').size()
  sizeof_cdr_track = [0, 0, 0].pack('i3').size()
  sizeof_cdr_cuesheet = [0, "\0", 0, 0, 0].pack('iPi3').size()
  CDRIOCBLANK   = _IOW('c', 100, sizeof_int)
  CDR_B_ALL     = 0x0
  CDR_B_MIN     = 0x1
  CDR_B_SESSION = 0x6

  CDIOCRESET              = _IO('c', 21)
  CDRIOCNEXTWRITEABLEADDR = _IOR('c', 101, sizeof_int)
  CDRIOCINITWRITER        = _IOW('c', 102, sizeof_int)
  CDRIOCINITTRACK         = _IOW('c', 103, sizeof_cdr_track)
  CDRIOCSENDCUE           = _IOW('c', 104, sizeof_cdr_cuesheet)
  CDRIOCFLUSH             = _IO('c', 105)
  CDRIOCFIXATE            = _IOW('c', 106, sizeof_int)
  CDRIOCREADSPEED         = _IOW('c', 107, sizeof_int)
  CDRIOCWRITESPEED        = _IOW('c', 108, sizeof_int)
  CDRIOCGETBLOCKSIZE      = _IOR('c', 109, sizeof_int)
  CDRIOCSETBLOCKSIZE      = _IOW('c', 110, sizeof_int)
  CDRIOCGETPROGRESS       = _IOR('c', 111, sizeof_int)

  CDR_MAX_SPEED = 0xffff
end

class Burncd
  include CDIO
  include CDRIO
  include DISK
  BLOCKS = 16
  BT2CTL = [
    0x0,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
    0x4, 0x4, 0x4, 0x4, 0x4, 0x4,  -1,  -1
  ]
  BT2DF  = [
    0x0,    -1,   -1,   -1,   -1,   -1,   -1,   -1,
    0x10, 0x30, 0x20,   -1, 0x21,   -1,   -1,   -1
  ]
  class InvalidWave < StandardError
  end
  class TrackInfo
    attr_accessor :fd, :name, :size, :block_size, :block_type
    attr_accessor :pregap, :addr
    def roundup_blocks
      (@size + @block_size - 1) / @block_size
    end
  end
  def initialize(config)
    @do_cleanup = false
    @config = config
    @do_confirm = @config[:confirm]
    @fd = File.open(@config[:device], "wb+")
    @saved_block_size = [0].pack('i')
    raise RuntimeError, 'ioctl(CDRIOGETBLOCKSIZE)' \
      if @fd.ioctl(CDRIOCGETBLOCKSIZE, @saved_block_size) < 0
    @saved_block_size = @saved_block_size.unpack('i')[0]
    raise RuntimeError, 'ioctl(CDRIOCWRITESPEED)' \
      if @fd.ioctl(CDRIOCWRITESPEED, [config[:speed]].pack('i')) < 0
    @do_cleanup = true
    @tracks = []
    @block_type = nil
    @block_size = nil
    @wave_check = false
    @done_stdin = false
    @cdopen = false
    @vcdbin = false
  end
  attr_accessor :do_cleanup
  attr_reader :block_type, :block_size, :wave_check
  def track_type=(type)
    case type
      when :raw
        @block_type = CDR_DB_RAW
        @block_size = 2352
        @wave_check = false
      when :audio
        @block_type = CDR_DB_RAW
        @block_size = 2352
        @wave_check = true
      when :data, :mode1
        @block_type = CDR_DB_ROM_MODE1
        @block_size = 2048
        @wave_check = false
      when :mode2
        @block_type = CDR_DB_ROM_MODE2
        @block_size = 2336
        @wave_check = false
      when :xamode1
        @block_type = CDR_DB_XA_MODE1
        @block_size = 2048
        @wave_check = false
      when :xamode2
        @block_type = CDR_DB_XA_MODE2_F2
        @block_size = 2324
        @wave_check = false
      when :vcd
        @block_type = CDR_DB_XA_MODE2_F2;
        @block_size = 2352
        @config[:dao] = true
        @config[:nogap] = true
        @wave_check = false
      when :vcdbin
        @block_type = CDR_DB_XA_MODE2_F2;
        @block_size = 2352
        @config[:dao] = true
        @config[:nogap] = false
        @wave_check = false
        @vcdbin = true
    end
  end
  def add_track(file)
    if @vcdbin
      raise ArgumentError, "Already have enough file for vcdbin" \
          if @vcdbin.is_a?(String)
      @vcdbin = file
      @tracks.clear()
      track = TrackInfo.new()
      track.name = @vcdbin
      track.pregap = 150
      track.block_size = @block_size
      track.block_type = @block_type
      track.size = 300 * @block_size
      @tracks.push(track)
      track = TrackInfo.new()
      track.name = @vcdbin
      track.pregap = 150
      track.block_size = @block_size
      track.block_type = @block_type
      track.size = File.size(@vcdbin) - (300 * @block_size) - (150 * @block_size)
      @tracks.push(track)
    else
      track = TrackInfo.new()
      if file == '-'
        if @done_stdin
          STDERR.puts 'skipping multiple usages of stdin'
          return
        else
          track.fd = STDIN
          track.size = -1
          @done_stdin = true
        end
      else
        track.fd = File.open(file, "rb")
        track.size = File.size(file)
        raise IOError, 'track.size < 0 ?' if track.size < 0
      end
      track.name = file
      track.block_size = @block_size
      track.block_type = @block_type
      #
      # XXX something fishy about cdrecord dao mixmode
      #     Only usefull in DAO
      #track.pregap = (@tracks.empty? || (@tracks[-1].block_type == track.block_type)) ? 150 : 255
      track.pregap = (@tracks.empty? || (@tracks[-1].block_type != track.block_type)) ? 150 : 0
      _setup_wavefile(track) \
        if @wave_check && track.size != -1 && /\.wav$/i =~ track.name
      if @config[:verbose]
        roundup_blocks = track.roundup_blocks()
        STDERR.printf( 
          "adding type 0x%02x file %s size %d KB %d blocks %s\n",
          track.block_type, track.name, track.size/1024,
          roundup_blocks,
          ((track.size / track.block_size) != roundup_blocks) ?
            "(0 padded)" :
            ""
        );
      end
      @tracks.push(track)
    end
  end
  def _setup_wavefile(track)
    begin
      header = track.fd.sysread(44)
      raise InvalidWave unless header.size() == 44
      header = header.unpack('a4Ia4a4Is2I2s2a4I')
      raise InvalidWave unless header[0] == 'RIFF' &&
        header[2] == 'WAVE' && header[3] == 'fmt ' &&
        header[6] == 2 && header[7] == 44100 &&
        header[10] == 16
      track.size -= 44
    rescue InvalidWave
      track.fd.sysseek(0, IO::SEEK_SET)
    end
  end
  def burn
    unless @tracks.empty?
      raise RuntimeError, 'ioctl(CDIOCSTART)' \
        if @fd.ioctl(CDIOCSTART, [0].pack('i')) < 0
      raise RuntimeError, 'ioctl(CDRIOCINITWRITER)' \
        if @fd.ioctl(CDRIOCINITWRITER, [@config[:test_write] ? 1 : 0].pack('i')) < 0
      if @config[:dao]
        do_DAO()
      else
        do_TAO()
      end
    end
  end
  def lba2msf(lba)
    lba += 150
    lba &= 0xffffff
    [lba / (60 * 75), (lba % (60 * 75)) / 75, (lba % (60 * 75)) % 75]
  end
  def msf2lba(min, sec, frm)
    (((min * 60) + sec) * 75) + frm - 150
  end
  private :lba2msf, :msf2lba
  def diskinfo
    # XXX sizeof(off_t) == 8, but ruby cannot deal with that!
    ret = "\0"*8
    raise RuntimeError, 'ioctl(DIOCGMEDIASIZE)' \
      if @fd.ioctl(DIOCGMEDIASIZE, ret)  < 0
    ret = ret.unpack('L')[0]
    if ret % 2352 == 0
      blk = ret / 2352
    elsif ret % 2048 == 0
      blk = ret / 2048
    else
      raise RuntimeError, 'ioctl(DIOCGMEDIASIZE) : Unknown blocksize'
    end
    m, s, f = lba2msf(blk - 150)
    STDOUT.printf("Total capacity: %02d:%02d:%02d (%d blocks, %d/%d MB)\n",
      m, s, f, blk, (blk * 2048) / 1024 / 1024, (blk * 2352) / 1024 / 1024)
  end
  def info
    hdr = [0, 0, 0].pack('SC2')
    raise RuntimeError, 'ioctl(CDIOREADTOCHEADER)' \
      if @fd.ioctl(CDIOREADTOCHEADER, hdr) < 0
    hdr = hdr.unpack('SC2')
    ntocentries = hdr[2] - hdr[1] + 1
    toc_buffer = [0, 0, 0].pack('xC2xN') * 100
    sizeof_cd_toc_entry = toc_buffer.size() / 100
    toc_ent = [
      CD_LBA_FORMAT, 0,
      (ntocentries + 1) * sizeof_cd_toc_entry,
      toc_buffer
    ].pack('C2SP')
    raise RuntimeError, 'ioctl(CDIOREADTOCENTRYS)' \
      if @fd.ioctl(CDIOREADTOCENTRYS, toc_ent) < 0
    tracks = []
    0.upto(ntocentries) do |i|
        ent = toc_buffer.slice!(0, sizeof_cd_toc_entry)
        bits = ent.slice!(0, 2)[1 .. -1].unpack('C')[0]
        is_data = ((bits & ~((bits >> 4) << 4)) & 4) != 0
        track, lba = ent.unpack('CxN')
        is_leadout = (i == ntocentries)
        if i > 0
          if is_data && !tracks[-1][2] && !is_leadout
            # XXX Possible CD-EXTRA
            tracks[-1] << (lba - (152 * 75))
          else
            tracks[-1] << lba
            tracks[-1][-1] -= 150 if is_data != tracks[-1][2] && !is_leadout
          end
        end
        tracks.push([track, lba, is_data, is_leadout])
    end
    STDOUT.printf(
      "Starting track = %d, ending track = %d, TOC size = %d bytes\n",
      hdr[1], hdr[2], hdr[0]
    )
    STDOUT.puts 'track     start  duration   block  length   type'
    STDOUT.puts '-------------------------------------------------'
    last_type = nil
    tracks.each do |num, lba_start, is_data, is_leadout, lba_end|
      m, s, f = lba2msf(lba_start)
      if is_leadout
        STDOUT.printf(
          "%5d  %2d:%02d.%02d         -  %6d       -      -\n",
          num, m, s, f, lba_start
        )
      else
        len = lba_end - lba_start
        dm, ds, df = lba2msf(len - 150)
        STDOUT.printf(
          "%5d  %2d:%02d.%02d  %2d:%02d.%02d  %6d  %6d  %5s\n",
          num, m, s, f, dm, ds, df, lba_start, len,
          is_data ? 'data' : 'audio'
        )
      end
    end
  end
  def msinfo
    # XXX
    raise RuntimeError, 'ioctl(CDRIOCINITTRACK)' \
      if @fd.ioctl(CDRIOCINITTRACK, [0, 0, 0].pack('i3')) < 0
    header = [0, 0, 0].pack('SC2')
    raise RuntimeError, 'ioctl(CDIOREADTOCHEADER)' \
      if @fd.ioctl(CDIOREADTOCHEADER, header) < 0
    single_entry = [
      CD_LBA_FORMAT, header.unpack('SC2')[2], 0, 0, 0
    ].pack('C2x3C2xN')
    raise RuntimeError, 'ioctl(CDIOREADTOCENTRY)' \
      if @fd.ioctl(CDIOREADTOCENTRY, single_entry) < 0
    addr = [0].pack('i')
    raise RuntimeError, 'ioctl(CDRIOCNEXTWRITEABLEADDR)' \
      if @fd.ioctl(CDRIOCNEXTWRITEABLEADDR, addr) < 0
    lasttrack = single_entry.unpack('C2x3C2xN')
    if ((lasttrack[2] & ~((lasttrack[2] >> 4) << 4)) & 4) != 0
      lastaddr = lasttrack[4]
    else
      lastaddr = 0
    end
    STDOUT.puts "#{lastaddr},#{addr.unpack('i')[0]}"
  end
  def fixate
    if @config[:fixate] && !@config[:dao]
      confirm()
      STDERR.puts 'fixating CD, please wait..' unless @config[:quiet]
      raise RuntimeError, 'ioctl(CDRIOCFIXATE)' \
        if @fd.ioctl(CDRIOCFIXATE, [@config[:multi] ? 1 : 0].pack('i')) < 0
    end
  end
  def eject
    if @config[:eject]
      raise RuntimeError, 'ioctl(CDIOCEJECT)' \
        if @fd.ioctl(CDIOCEJECT) < 0
    end
    if @config[:close]
      sleep(0.5)
      raise RuntimeError, 'ioctl(CDIOCCLOSE)' \
        if @fd.ioctl(CDIOCCLOSE) < 0
    end
  end
  def cleanup
    @fd.ioctl(CDRIOCSETBLOCKSIZE, [@saved_block_size].pack('i')) \
      if @do_cleanup && !@fd.closed? && @saved_block_size.is_a?(Integer)
    @do_cleanup = false
  end
  def close
    @fd.close() unless @fd.closed?
    @tracks.each do |track|
      track.fd.close() if track.fd &&  !track.fd.closed?
    end
  end
  def erase
    _erase_blank(CDR_B_ALL)
  end
  def blank
    _erase_blank(CDR_B_MIN)
  end
  def _erase_blank(blank)
    confirm()
    quiet = @config[:quiet]
    task = (blank == CDR_B_ALL) ? 'eras' : 'blank'
    STDERR.printf("%sing CD, please wait..\r", task) unless quiet
    raise RuntimeError, 'ioctl(CDRIOCBLANK)' \
      if @fd.ioctl(CDRIOCBLANK, [blank].pack('i')) < 0
    #percent = [0].pack('i')
    #_percent = nil
    #error = 0
    #_last = 0
    ind = %w[- \\ | /]
    idx = 0
    while true
      sleep(0.25)
      begin
        raise Errno::EBUSY if idx % 4 != 0
        error = @fd.ioctl(CDIOCRESET)
      rescue Errno::EBUSY
        error = -1
      end
      if error == 0
        STDERR.printf("%sing CD - %s DONE          \r", task, ind[idx % 4]) \
            unless quiet
        break
      else
        STDERR.printf("%sing CD - %s               \r", task, ind[idx % 4]) \
            unless quiet
      end
      idx += 1
      #error = @fd.ioctl(CDRIOCGETPROGRESS, percent)
      #_percent = percent.unpack('i')[0]
      #_percent = 0 unless _percent.is_a?(Integer)
      #STDERR.printf("%sing CD - %d %% done     \r", task, _percent) \
      #      if _percent > 0 && !quiet
      #break if error != 0 || _percent == 100 || (_percent == 0 && _last > 90)
      #_last = _percent
    end
    STDERR.print "\n"
  end
  def cue_ent(ctl, adr, track, idx, dataform, scms, lba)
    lba += 150
    # litle-endian, unsigned 4Bit truncation
    [
      ((ctl & 0xf) << 4) | (adr & 0xf),
      track, idx, dataform, scms,
      lba / (60 * 75), (lba % (60 * 75)) / 75, (lba % (60 * 75)) % 75
    ].pack('C8')
  end
  def do_DAO
    verbose = @config[:verbose]
    cdformat = CDR_SESS_CDROM
    j = 0
    cue = ''
    STDERR.puts 'Burning mode: DAO' if verbose
    addr = [0].pack('i')
    raise RuntimeError, 'ioctl(CDRIOCNEXTWRITEABLEADDR)' \
      if @fd.ioctl(CDRIOCNEXTWRITEABLEADDR, addr) < 0
    addr = addr.unpack('i')[0]
    STDERR.puts "next writeable LBA #{addr}" if verbose
    if addr != -150
      STDERR.puts "resetting next writable LBA!" if verbose
      addr = -150
    end
    prevtrack = @tracks[0]
    cue << cue_ent(
      BT2CTL[prevtrack.block_type], 0x01, 0x00, 0x0,
      (BT2DF[prevtrack.block_type] & 0xf0) |
      (prevtrack.block_type < 8 ? 0x01 : 0x04), 0x00, addr
    )
    @tracks.each_with_index do |track, i|
      raise RuntimeError, 'track type not supported in DAO mode' \
        if BT2CTL[track.block_type] < 0 || BT2DF[track.block_type] < 0
      cdformat = CDR_SESS_CDROM_XA \
        if track.block_type >= CDR_DB_XA_MODE1
      if track.pregap > 0
        cue << cue_ent(
          BT2CTL[track.block_type], 0x01, i + 1, 0x0,
          BT2DF[track.block_type], 0x00, addr
        )
        addr += track.pregap
      end
      track.addr = addr
      STDERR.puts "track #{i + 1}: addr=#{track.addr} pregap=#{track.pregap}" \
        if verbose
      cue << cue_ent(
        BT2CTL[track.block_type], 0x01, i + 1, 0x1,
        BT2DF[track.block_type], 0x00, addr
      )
      addr += track.roundup_blocks()
      prevtrack = track
    end
    cue << cue_ent(
      BT2CTL[prevtrack.block_type], 0x01, 0xaa, 0x01,
      (BT2DF[prevtrack.block_type] & 0xf0) |
      (prevtrack.block_type < 8 ? 0x01 : 0x04), 0x00, addr
    )
    cuesheet = [
      cue.size(), cue, cdformat,
      @config[:multi] ? CDR_SESS_MULTI : CDR_SESS_NONE,
      @config[:test_write] ? 1 : 0
    ].pack('iPi3')
    if verbose
      # XXX
      STDERR.print 'CUE sheet:'
      cue.unpack("C#{cue.size()}").each_with_index do |val, i|
        if i % 8 == 0
          STDERR.printf("\n %02X", val)
        else
          STDERR.printf(" %02X", val)
        end
      end
      STDERR.printf("\n")
    end
    confirm()
    raise RuntimeError, 'ioctl(CDRIOCSENDCUE)' \
      if @fd.ioctl(CDRIOCSENDCUE, cuesheet) < 0
    prevtrack = nil
    retry_pregap = -1
    paddr = nil
    buf = ''
    begin 
      if @vcdbin
        @tracks.clear()
        track = TrackInfo.new()
        track.name = @vcdbin
        track.fd = File.open(@vcdbin, "rb")
        track.block_size = @block_size
        track.block_type = @block_type
        track.pregap = 150
        track.addr = 0
        track.size = File.size(@vcdbin)
        @tracks.push(track)
      end
      @tracks.each_with_index do |track, i|
        if track.pregap > 0
          raise RuntimeError, 'ioctl(CDRIOCSETBLOCKSIZE)' \
            if @fd.ioctl(CDRIOCSETBLOCKSIZE, [track.block_size].pack('i')) < 0
          total = track.pregap * track.block_size
          paddr = track.addr - track.pregap
          @fd.sysseek(paddr * track.block_size, IO::SEEK_SET)
          retry_pregap = total if i == 0 && paddr < 0
          STDERR.puts "writing pregap addr = #{paddr} total = #{track.pregap} blocks / #{total} bytes" \
            if verbose
          while total > 0
            buf.replace("\0"*MIN(track.block_size * BLOCKS, total))
            # XXX workaround for FreeBSD 5+ GEOM !@#$%^&*
            begin
              write_size = @fd.syswrite(buf)
            rescue Errno::EIO => exp
              if retry_pregap == total
                @fd.sysseek(track.addr * track.block_size, IO::SEEK_SET)
                retry_pregap = -1
                retry
              end
              raise exp
            end
            if buf.size() != write_size
              STDERR.puts "pregap: only wrote #{write_size} of #{buf.size} bytes"
              break
            end
            total -= write_size
          end
        end
        raise RuntimeError, 'write_file' unless write_file(track)
        prevtrack = track
      end
    rescue
      @fd.ioctl(CDRIOCFLUSH)
      raise
    end
    @fd.ioctl(CDRIOCFLUSH)
  end
  def do_TAO
    STDERR.puts 'Burning mode: TAO' if @config[:verbose]
    confirm()
    quiet = @config[:quiet]
    addr = [0].pack('i')
    @tracks.each do |track|
      raise RuntimeError, 'ioctl(CDRIOCINITTRACK)' \
        if @fd.ioctl(
          CDRIOCINITTRACK,
          [
            track.block_type,
            @config[:preemp] ? 1 : 0,
            @config[:test_write] ? 1 : 0
          ].pack('i3')
        ) < 0
      raise RuntimeError, 'ioctl(CDRIOCNEXTWRITEABLEADDR)' \
        if @fd.ioctl(CDRIOCNEXTWRITEABLEADDR, addr) < 0
      track.addr = addr.unpack('i')[0]
      track.addr = 0 unless track.addr.is_a?(Integer)
      STDERR.puts "next writeable LBA #{track.addr}" unless quiet
      begin
        write_file(track)
      rescue
        @fd.ioctl(CDRIOCFLUSH)
        raise
      end
      raise RuntimeError, 'ioctl(CDRIOCFLUSH)' \
        if @fd.ioctl(CDRIOCFLUSH) < 0
    end
  end
  def write_file(track)
    @tot_size ||= 0
    quiet = @config[:quiet]
    filesize = track.size / 1024
    raise RuntimeError, 'ioctl(CDRIOCSETBLOCKSIZE)' \
      if @fd.ioctl(CDRIOCSETBLOCKSIZE, [track.block_size].pack('i')) < 0
    begin
      @fd.sysseek(track.addr * track.block_size, IO::SEEK_SET) \
        if track.addr >= 0
    rescue
    end
    STDERR.puts "addr = #{track.addr} size = #{track.size} blocks = #{track.roundup_blocks()}" \
      if @config[:verbose]
    unless quiet
      if track.fd == STDIN
        STDERR.puts 'writing from stdin'
      else
        STDERR.puts "writing from file #{track.name} size #{filesize} KB"
      end
    end
    size = 0
    count = 0
    buf = ''
    res = 0
    mod = 0
    read_size = (track.size == -1) ? track.block_size * BLOCKS : 0
    begin
      while true
        read_size = MIN(track.size - size, track.block_size * BLOCKS) \
          if track.size != -1
        buf.replace(track.fd.sysread(read_size))
        count = buf.size()
        raise IOError, "sysread() < 1" if count < 1
        mod = count % track.block_size
        if mod != 0
          buf << "\0"*(track.block_size - mod)
          count = buf.size()
        end
        begin
          res = @fd.syswrite(buf)
          raise IOError unless res == count
        rescue => err
          STDERR.print "\nonly wrote #{res || 0} of #{count} bytes err=#{err.class}\n"
          raise EOFError
        end
        size += count
        @tot_size += count
        unless quiet
          STDERR.print "written this track #{size / 1024} KB"
          STDERR.print " (#{(size / 1024) * 100 / filesize}%)" \
            if track.size != -1 && filesize > 0
          STDERR.print " total #{@tot_size / 1024} KB\r"
        end
        break if track.size != -1 && size >= track.size
      end
    rescue EOFError
      raise if track.size != -1
    end
    STDERR.print "\n" unless quiet
    track.fd.close()
    true
  end
  def confirm
    if @do_confirm
      #STDERR.print 'Starting real write in 10 seconds. Press Ctrl+C to abort.'
      #9.downto(0) do |i|
      #  sleep(1)
      #  STDERR.print "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b #{i} seconds. Press Ctrl+C to abort."
      #end
      10.downto(0) do |i|
        STDERR.printf("Starting real write in %2d seconds. Press Ctrl+C to abort.\r", i)
        sleep(1)
      end
      STDERR.print "\n"
      @do_confirm = false
    end
  end
  private :_erase_blank, :_setup_wavefile
  private :do_DAO, :do_TAO, :write_file, :cue_ent
end

config = {
  :dao => false,
  :eject => false,
  :close => false,
  :device => ENV['CDROM'] || '/dev/acd0',
  :list => nil,
  :confirm => true,
  :multi => false,
  :nogap => false,
  :preemp => false,
  :quiet => false,
  :speed => 4,
  :test_write => false,
  :fixate => false,
  :verbose => false
}

def usage
  STDERR.print <<-EOF
Usage: #{File.basename($0)} [-cdelmnpqtvy] [-f device] [-s speed] [command] [command file ...]
EOF
  exit(1)
end

def fatal(status, msg)
  STDERR.puts "#{File.basename($0)}: #{msg}"
  exit(status)
end

parser = GetoptLong.new()
parser.quiet = true
parser.set_options(
  ['-c', GetoptLong::NO_ARGUMENT],
  ['-d', GetoptLong::NO_ARGUMENT],
  ['-e', GetoptLong::NO_ARGUMENT],
  ['-l', GetoptLong::NO_ARGUMENT],
  ['-m', GetoptLong::NO_ARGUMENT],
  ['-n', GetoptLong::NO_ARGUMENT],
  ['-p', GetoptLong::NO_ARGUMENT],
  ['-q', GetoptLong::NO_ARGUMENT],
  ['-t', GetoptLong::NO_ARGUMENT],
  ['-v', GetoptLong::NO_ARGUMENT],
  ['-y', GetoptLong::NO_ARGUMENT],
  ['-f', GetoptLong::REQUIRED_ARGUMENT],
  ['-s', GetoptLong::REQUIRED_ARGUMENT]
)

begin
  parser.each do |opt, arg|
    case opt
      when '-c'
        config[:close] = true
      when '-d'
        config[:dao] = true
      when '-e'
        config[:eject] = true
      when '-l'
        config[:list] = arg
      when '-m'
        config[:multi] = true
      when '-n'
        config[:nogap] = true
      when '-p'
        config[:preemp] = true
      when '-q'
        config[:quiet] = true
      when '-t'
        config[:test_write] = true
      when '-v'
        config[:verbose] = true
      when '-y'
        config[:confirm] = false
      when '-f'
        fatal(1, "Invalid device: #{arg}") unless File.chardev?(arg)
        config[:device] = arg
      when '-s'
        if arg.casecmp('max') == 0
          config[:speed] = CDRIO::CDR_MAX_SPEED
        else
          config[:speed] = arg.to_i * 177
        end
        if config[:speed] <= 0
          fatal(1, "Invalid speed: #{arg}")
        end
    end
  end
rescue GetoptLong::AmbigousOption, GetoptLong::InvalidOption,
    GetoptLong::MissingArgument, GetoptLong::NeedlessArgument,
    ArgumentError => err
  STDERR.puts "#{File.basename($0)}: #{err.message}"
  usage()
end

usage() if ARGV.empty?
begin
  bcd = Burncd.new(config)
  ARGV.each do |arg|
    case arg
      when /^fixate$/i
        config[:fixate] = true
        break
      when /^msinfo$/i
        bcd.msinfo()
        break
      when /^diskinfo$/i
        bcd.diskinfo()
        break
      when /^info/i
        bcd.info()
        break
      when /^erase$/i
        bcd.erase()
        next
      when /^blank$/i
        bcd.blank()
        next
      when /^(raw|audio|data|(xa)?mode[12]|vcd|vcdbin)$/i
        bcd.track_type = arg.downcase.to_sym
        next
    end
    raise RuntimeError, 'no data format selected' \
      unless bcd.block_type && bcd.block_size
    bcd.add_track(arg)
  end
  bcd.burn()
  bcd.fixate()
  bcd.cleanup()
  bcd.eject()
  bcd.close()
rescue Interrupt
  STDERR.puts "\nAborting..."
  if bcd
    bcd.cleanup()
    bcd.close()
  end
  exit(1)
rescue => err
  STDERR.puts "#{File.basename($0)}: #{err.message}"
  if bcd
    bcd.cleanup()
    bcd.close()
  end
  exit(1)
end
