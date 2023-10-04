{
  description = "Webots Robot Simulator";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    webots.url = https://github.com/cyberbotics/webots/releases/download/R2023b/webots-R2023b-x86-64.tar.bz2;
    webots.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, webots }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) { inherit system; };
        dependencies = with pkgs; [
          boost
          cmake
          curl
          dbus
          expat
          ffmpeg
          fox
          freeimage
          freetype
          gdal
          gl2ps
          glew-egl
          glib
          gnumake
          gnupg
          jdk
          krb5
          libGL
          libGLU
          libgcrypt
          libssh2
          libuuid
          libxkbcommon
          libxml2
          libzip
          lsb-release
          nss_latest
          pbzip2
          pkg-config
          prelink
          proj
          python311
          qt6.full
          readline
          swig
          unzip
          wget
          xercesc
          xorg.libX11
          xorg.libXcomposite
          xorg.libXtst
          xorg.libxcb
          xorg.xcbutil
          xvfb-run
          zip
        ];
      in
      rec {
        formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
        packages.default = pkgs.buildFHSUserEnv {
          name = "webots";
          targetPkgs = pkgs: dependencies;
          runScript = pkgs.writeScript "webots"
            ''
              export QT_PLUGIN_PATH=${webots}/lib/webots/qt/plugins
              export WEBOTS_HOME=${webots}
              exec ${webots}/webots "$@"
            '';
          meta.description = "Webots in FHS environment";
        };
        apps.default = {
          type = "app";
          program = "${packages.default}/bin/webots";
        };
        devShells.default = pkgs.mkShell {
          buildInputs = dependencies;
        };
      });
}
