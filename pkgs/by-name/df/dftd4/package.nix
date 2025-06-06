{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  python3,
  blas,
  lapack,
  mctc-lib,
  mstore,
  multicharge,
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "dftd4";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "dftd4";
    repo = "dftd4";
    rev = "v${version}";
    hash = "sha256-dixPCLH5dWkE2/7ghGEXJmX2/g1DN30dB4jX2d7fmio=";
  };

  patches = [
    # Make sure fortran headers are installed directly in /include
    ./fortran-module-dir.patch
  ];

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    blas
    lapack
    mctc-lib
    mstore
    multicharge
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build \
      config/install-mod.py \
      app/tester.py
  '';

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Generally Applicable Atomic-Charge Dependent London Dispersion Correction";
    mainProgram = "dftd4";
    license = with licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    homepage = "https://github.com/grimme-lab/dftd4";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
