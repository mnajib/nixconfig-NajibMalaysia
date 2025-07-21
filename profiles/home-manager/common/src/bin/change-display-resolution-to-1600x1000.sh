cvt 1600 1000
## 1600x1000 59.87 Hz (CVT 1.60MA) hsync: 62.15 kHz; pclk: 132.25 MHz
#Modeline "1600x1000_60.00"  132.25  1600 1696 1864 2128  1000 1003 1009 1038 -hsync +vsync

xrandr --newmode "1600x1000_60.00"  132.25  1600 1696 1864 2128  1000 1003 1009 1038 -hsync +vsync
xrandr --addmode LVDS-1 1600x1000_60.00

xrandr --output LVDS-1 --mode 1600x1000_60.00