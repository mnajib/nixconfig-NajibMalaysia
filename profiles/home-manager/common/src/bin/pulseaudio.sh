#pacmd list-cards

#nvidia HDMI
# volume: 60
# alsa_card.pci-0000_01_00.1

#intel - motherboard build-in - realtek?
# volume: 100
# alsa_card.pci-0000_00_1b.0

#EMU20k1 [Sound Blaster X-Fi Series] (X-Fi Platinum)
# volume: 60
# alsa_card.pci-0000_05_00.0

# volume ratio test (nvidia hdmi,
#70,100,50

#pacmd list-sinks  | grep -e 'name:'  -e 'alsa.device ' -e 'alsa.subdevice '

#pacmd load-module module-combine-sink sink_name=combined slaves=alsa_output.pci-0000_01_00.1.hdmi-stereo-extra3,alsa_output.pci-0000_00_1b.0.analog-stereo,alsa_output.pci-0000_05_00.0.analog-stereo
pacmd unload-module module-combine-sink
pacmd load-module module-combine-sink sink_name=combined slaves=alsa_output.pci-0000_01_00.1.hdmi-stereo-extra3,alsa_output.pci-0000_00_1b.0.analog-stereo,alsa_output.pci-0000_05_00.0.analog-stereo sink_properties=device.description=Combined
