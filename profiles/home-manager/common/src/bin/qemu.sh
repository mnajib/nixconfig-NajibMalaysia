#!/bin/sh
#qemu-system-x86_64 -soundhw es1370 -net nic -net user -cdrom /home/oem/Downloads/android-x86_64-9.0-rc1.iso
#qemu-system-x86_64 -soundhw es1370 -net nic -net user -hda win10.qcow2.img -boot once=d,strict=on -cdrom ReactOS-0.4.13.iso
#qemu-system-x86_64 -m 2G -net nic -net user -hda win10.qcow2.img
qemu-system-x86_64 -m 2G -net nic -net user -hda /data/data/win10.qcow2.img -cdrom /data/data/tribler/Windows\ 10\ Pro\ en-US\ v1909\ x64\ BiT\ Activated-KBO/Windows\ 10\ Pro\ en-US\ v1909\ x64\ BiT\ Activated.iso  -boot once=d
