{
  buildGoModule,
  docker-credential-gcr,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule rec {
  pname = "docker-credential-gcr";
  version = "2.1.28";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    tag = "v${version}";
    hash = "sha256-8aFkafSsn8BZz6tB3wh2OqQA6E10NyY3J1XqNgelk+A=";
  };

  postPatch = ''
    rm -rf ./test
  '';

  vendorHash = "sha256-n6QnVPBCGJpaHxywYjk+qCN0FXmQAvkQPu6vHPv5QJA=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/docker-credential-gcr/v2/config.Version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = docker-credential-gcr;
      command = "docker-credential-gcr version";
    };
    updateScript = nix-update-script { };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = "https://github.com/GoogleCloudPlatform/docker-credential-gcr";
    changelog = "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      suvash
      anthonyroussel
    ];
    mainProgram = "docker-credential-gcr";
  };
}
