{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python with pip
    (python3.withPackages (ps: with ps; [
      pip
      setuptools
      wheel
    ]))

    # ZMK/Zephyr dependencies
    cmake
    ninja
    gperf
    ccache
    dfu-util
    dtc
    wget
    xz
    file
    gcc-arm-embedded

    # West and build tools
    just
    yq-go
  ];

  shellHook = ''
    if [ ! -f .venv/bin/activate ] || ! .venv/bin/python --version &>/dev/null; then
      echo "Creating/rebuilding Python venv..."
      rm -rf .venv
      python3 -m venv .venv
      .venv/bin/pip install -r zephyr/scripts/requirements-base.txt protobuf grpcio-tools
    fi

    source .venv/bin/activate
    echo "Nix environment loaded for ZMK development"
    echo "Python: $(python3 --version)"
  '';
}
