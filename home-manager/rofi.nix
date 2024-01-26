{
  config,
  ...
}:
{
  home.file."./config/rofi" = {
    source = ./src/.config/rofi;
    recursive = true;
  };
}
