# before nix-shell
# export NIX_PATH="nixpkgs=/home/pamplemousse/Workspace/nixpkgs:${NIX_PATH}"

# TODO: more elegant way to do the following:
#   install unicorn related stuff:
# nix-shell -p python2 python3Packages.virtualenvwrapper
# source $(command -v virtualenvwrapper.sh)
# workon venv
# UNICORN_QEMU_FLAGS="--python=$(which python2)" pip install unicorn

with import <nixpkgs> { };

let myPython3 =
  python3.withPackages(ps: with ps; [
    python3Packages.nose
    python3Packages.ipdbplugin
    python3Packages.networkx

    # the angr contigent
    python3Packages.ailment
    python3Packages.archinfo
    python3Packages.claripy
    python3Packages.cle
    python3Packages.z3-solver
  ])
;
in stdenv.mkDerivation rec {
  name = "angr-env";

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    python3Packages.virtualenvwrapper
    myPython3 # For CPython install
    # pypy3     # for PyPy install

    nasm
    libxml2
    libxslt
    libffi
    readline
    libtool
    glib
    debootstrap
    pixman
    qt5.qtdeclarative
    openssl
    jdk8

    # needed for pure environments
    which
  ];

  shellHook = ''
      source $(command -v virtualenvwrapper.sh)
      [ -d "$HOME/.virtualenvs/venv" ] && workon venv
  '';
}
