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
    # Create a local pip install directory
    export PIP_PREFIX="$PWD/.venv"
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"

    # Ensure the directory exists
    mkdir -p "$PIP_PREFIX"

    echo "Nix environment loaded for ZMK development"
    echo "Python: $(python3 --version)"
  '';
}
