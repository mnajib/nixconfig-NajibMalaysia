"*" = {
    red = mkLiteral "rgba ( 220, 50, 47, 100 % )";
    selected-active-foreground = mkLiteral "var(background)";
    lightfg = mkLiteral "rgba ( 88, 104, 117, 100 % )";
    separatorcolor = mkLiteral "var(foreground)";
    urgent-foreground = mkLiteral "var(red)";
    alternate-urgent-background = mkLiteral "var(lightbg)";
    lightbg = mkLiteral "rgba ( 238, 232, 213, 100 % )";
    background-color = mkLiteral "transparent";
    border-color = mkLiteral "var(foreground)";
    normal-background = mkLiteral "var(background)";
    selected-urgent-background = mkLiteral "var(red)";
    alternate-active-background = mkLiteral "var(lightbg)";
    spacing = 2;
    blue = mkLiteral "rgba ( 38, 139, 210, 100 % )";
    alternate-normal-foreground = mkLiteral "var(foreground)";
    urgent-background = mkLiteral "var(background)";
    selected-normal-foreground = mkLiteral "var(lightbg)";
    active-foreground = mkLiteral "var(blue)";
    background = mkLiteral "rgba ( 253, 246, 227, 100 % )";
    selected-active-background = mkLiteral "var(blue)";
    active-background = mkLiteral "var(background)";
    selected-normal-background = mkLiteral "var(lightfg)";
    alternate-normal-background = mkLiteral "var(lightbg)";
    foreground = mkLiteral "rgba ( 0, 43, 54, 100 % )";
    selected-urgent-foreground = mkLiteral "var(background)";
    normal-foreground = mkLiteral "var(foreground)";
    alternate-urgent-foreground = mkLiteral "var(red)";
    alternate-active-foreground = mkLiteral "var(blue)";
};
"element" = {
    padding: 1px ;
    cursor:  pointer;
    spacing: 5px ;
    border:  0;
}
element normal.normal {
    background-color: var(normal-background);
    text-color:       var(normal-foreground);
}
element normal.urgent {
    background-color: var(urgent-background);
    text-color:       var(urgent-foreground);
}
element normal.active {
    background-color: var(active-background);
    text-color:       var(active-foreground);
}
element selected.normal {
    background-color: var(selected-normal-background);
    text-color:       var(selected-normal-foreground);
}
element selected.urgent {
    background-color: var(selected-urgent-background);
    text-color:       var(selected-urgent-foreground);
}
element selected.active {
    background-color: var(selected-active-background);
    text-color:       var(selected-active-foreground);
}
element alternate.normal {
    background-color: var(alternate-normal-background);
    text-color:       var(alternate-normal-foreground);
}
element alternate.urgent {
    background-color: var(alternate-urgent-background);
    text-color:       var(alternate-urgent-foreground);
}
element alternate.active {
    background-color: var(alternate-active-background);
    text-color:       var(alternate-active-foreground);
}
element-text {
    background-color: transparent;
    cursor:           inherit;
    highlight:        inherit;
    text-color:       inherit;
}
element-icon {
    background-color: transparent;
    size:             1.0000em ;
    cursor:           inherit;
    text-color:       inherit;
}
window {
    padding:          5;
    background-color: var(background);
    border:           1;
}
mainbox {
    padding: 0;
    border:  0;
    children: [inputbar,message,listview,mode-switcher];
}
mode-switcher {
    padding:      1px;
    border-color: Gray;
    border:       1px 1px 1px 1px;
}
message {
    padding:      1px ;
    border-color: var(separatorcolor);
    border:       2px dash 0px 0px ;
}
textbox {
    text-color: var(foreground);
}
listview {
    padding:      2px 0px 0px ;
    scrollbar:    true;
    border-color: var(separatorcolor);
    spacing:      2px ;
    /*fixed-height: 0;*/
    fixed-height: 100px;
    border:       2px dash 0px 0px ;
}
scrollbar {
    width:        4px ;
    padding:      0;
    handle-width: 8px ;
    border:       0;
    handle-color: var(normal-foreground);
}
sidebar {
    border-color: var(separatorcolor);
    border:       2px dash 0px 0px ;
}
button {
    cursor:     pointer;
    spacing:    0;
    background-color: rgba ( 88, 104, 117, 30 % );
    text-color: var(normal-foreground);
    padding:      1px;
    border-color: Gray;
    border:       1px 1px 1px 1px;
}
button selected {
    background-color: var(selected-normal-background);
    text-color:       var(selected-normal-foreground);
    padding:      1px;
    border-color: Gray;
    border:       1px 1px 1px 1px;
}
num-filtered-rows {
    expand:     false;
    text-color: Gray;
}
num-rows {
    expand:     false;
    text-color: Gray;
}
textbox-num-sep {
    expand:     false;
    str:        "/";
    text-color: Gray;
}
inputbar {
    padding:    1px ;
    /*spacing:    0px ;*/
    spacing:    8px ;
    text-color: var(normal-foreground);
    children:   [ "prompt","textbox-prompt-colon","entry","num-filtered-rows","textbox-num-sep","num-rows","case-indicator" ];
}
case-indicator {
    spacing:    0;
    text-color: var(normal-foreground);
}
entry {
    text-color:        var(normal-foreground);
    cursor:            text;
    spacing:           0;
    placeholder-color: Gray;
    placeholder:       "Type to filter";
}
prompt {
    spacing:    0;
    text-color: var(normal-foreground);
}
textbox-prompt-colon {
    margin:     0px 0.3000em 0.0000em 0.0000em ;
    expand:     false;
    str:        ":";
    text-color: inherit;
}
