#cvt 1536 960
## 1536x960 59.91 Hz (CVT 1.47MA) hsync: 59.67 kHz; pclk: 121.25 MHz
#Modeline "1536x960_60.00"  121.25  1536 1624 1784 2032  960 963 969 996 -hsync +vsync

#xrandr --newmode "1600x1000_60.00"  132.25  1600 1696 1864 2128  1000 1003 1009 1038 -hsync +vsync^C

#xrandr --newmode "1536x960_60.00"  121.25  1536 1624 1784 2032  960 963 969 996 -hsync +vsync

#xrandr --addmode LVDS-1 1536x960_60.00
       
xrandr --output LVDS-1 --mode  1536x960_60.00
