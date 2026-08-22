#!/usr/bin/env bash
set -euo pipefail

EXTENSIONS=(
  "uBlock Origin|cjpalhdlnbpafiamejdnhcphjbkeiagm"
  "Bitwarden|nngceckbapebfimnlniiiahkandclblb"
)

BROWSER_VERSION="$(nix eval --raw nixpkgs#ungoogled-chromium.version | cut -d. -f1)"
CRX_URL="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${BROWSER_VERSION}&x=id%3D%s%26installsource%3Dondemand%26uc"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

OUT="$(dirname "$0")/extensions.nix"

{
  cat <<'EOF'
{browserVersion}: let
  createChromiumExtensionFor = version: {
    id,
    sha256,
    version,
  }: {
    inherit id;
    crxPath = builtins.fetchurl {
      url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      name = "${id}.crx";
      inherit sha256;
    };
    inherit version;
  };
  createChromiumExtension = createChromiumExtensionFor browserVersion;
in [
EOF

  for entry in "${EXTENSIONS[@]}"; do
    name="${entry%%|*}"
    id="${entry##*|}"
    url="$(printf '%s' "$CRX_URL" | sed "s/%s/${id}/")"

    sha256="$(nix-prefetch-url "$url")"
    curl -fsSL -o "$TMPDIR/${id}.crx" "$url"
    version="$(python3 -c "import zipfile,json; print(json.loads(zipfile.ZipFile('$TMPDIR/${id}.crx').read('manifest.json'))['version'])")"

    cat <<EOF
  (createChromiumExtension {
    # ${name}
    id = "${id}";
    sha256 = "${sha256}";
    version = "${version}";
  })
EOF
  done

  printf ']\n'
} > "$OUT"

echo "wrote $OUT"
