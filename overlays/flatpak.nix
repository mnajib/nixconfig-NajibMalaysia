(final: prev: {
  flatpak = prev.flatpak.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      substituteInPlace $out/share/flatpak/triggers/desktop-database.trigger \
        --replace-fail update-desktop-database ${final.desktop-file-utils}/bin/update-desktop-database
      substituteInPlace $out/share/flatpak/triggers/gtk-icon-cache.trigger \
        --replace-fail cp ${final.coreutils}/bin/cp \
        --replace-fail gtk-update-icon-cache ${final.gtk3}/bin/gtk-update-icon-cache \
        --replace-fail /usr/share/icons/hicolor/index.theme ${final.hicolor-icon-theme}/share/icons/hicolor/index.theme
      substituteInPlace $out/share/flatpak/triggers/mime-database.trigger \
        --replace-fail update-mime-database ${final.shared-mime-info}/bin/update-mime-database
    '';
  });
})
