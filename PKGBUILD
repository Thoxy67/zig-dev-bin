# Contributor: Thoxy <thi.hur67@gmail.com>

pkgname=zig-dev-bin
epoch=1
pkgver=0.11.0_dev.2995+d70853ba3
pkgrel=1
pkgdesc="A general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software"
arch=('x86_64' 'aarch64')
url="https://ziglang.org/"
license=('MIT')
makedepends=(curl jq minisign)
options=('!strip')
provides=('zig')
conflicts=('zig')
shasums=(
    'SKIP'
)

plain ''
plain '                                     z'
plain '                                  zzz'
plain '                             zzzzzz'
plain 'zzzzzzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzz'
plain 'zzzzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzz'
plain 'zzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzz'
plain 'zzzzz                zzzzzz      zzzzz'
plain 'zzzzz              zzzzzz        zzzzz'
plain 'zzzzz            zzzzzz          zzzzz'
plain 'zzzzz          zzzzzz            zzzzz'
plain 'zzzzz        zzzzzz              zzzzz'
plain 'zzzzz      zzzzzz                zzzzz'
plain 'zzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzz'
plain 'zzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzzzz'
plain 'zzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzzzzzz'
plain '   zzzzzz'
plain ' zzz'
plain 'z'
plain ''

# https://ziglang.org/download/
ZIG_MINISIGN_KEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U";

# Prints a warning message to stderr
warning() {
    echo -en "\e[33;1mWARNING\e[0m: " >&2;
    echo "$@" >&2;
}

pkgver() {
    local index_file="${srcdir}/zig-version-index.json";
    # Invalidate old verison-index.json
    #
    # If we put version-index in `source` then it would be cached...
    if [[ -x "$index_file" ]]; then
        rm "$index_file";
    fi
    curl -sS "https://ziglang.org/download/index.json" -o "$index_file"
    jq -r .master.version "$index_file" | sed 's/-/_/'
}

prepare() {
    local newver="$(pkgver)";
    pushd "${srcdir}" > /dev/null;
    local index_file="zig-version-index.json";
    local newurl="$(jq -r ".master.\"${CARCH}-linux\".tarball" $index_file)";
    local newurl_sig="$newurl.minisig";
    local newfile="zig-linux-${CARCH}-${newver}.tar.xz";
    local newfile_sig="$newfile.minisig";
    source+=("${newfile}:${newurl}" "${newfile_sig}:${newurl_sig}")
    local expected_hash="$(jq -r ".master.\"${CARCH}-linux\".shasum" "$index_file")"
    sha256sums+=("$expected_hash" "SKIP")
    if [[ -f "$newfile" && -f "$newfile_sig" ]]; then
        echo "Reusing existing $newfile (and signature)";
    else
        echo "Downloading Zig $newver from $newurl";
        curl -Ss "$newurl" -o "$newfile";
        echo "Downloading signature...";
        curl -Ss "$newurl_sig" -o "$newfile_sig";
    fi;
    echo "" >&2;
    local actual_hash="$(sha256sum "$newfile" | grep -oE '^\w+')"
    if [[ "$expected_hash" != "$actual_hash" ]]; then
        echo "ERROR: Expected hash $expected_hash for $newfile, but got $actual_hash" >&2;
        exit 1;
    fi;
    echo "Using minisign to check signature";
    if ! minisign -V -P "$ZIG_MINISIGN_KEY" -m "$newfile" -x "$newfile_sig"; then
        echo "ERROR: Failed to check signature for $newfile" >&2;
        exit 1;
    fi
    echo "Extracting file";
    tar -xf "$newfile";
    popd > /dev/null;
}

RELATIVE_LANGREF_FILE="docs/langref.html";
# All of these must be present for 
RELATIVE_STDLIB_DOC_FILES=("docs/std/index.html" "docs/std/main.js" "docs/std/data.js");
check() {
    local missing_docs=();
    # Zig has had long-running issues with the location
    # of the docs directory.
    # See issue https://github.com/ziglang/zig/issues/9158
    #
    # We check that it's present, and warn otherwise
    # Alternative is failing the whole build just over docs
    if [[ ! -f "$RELATIVE_LANGREF_FILE" ]]; then
        missing_docs+=("langref.html");
    fi
    for stdlib_file in "${RELATIVE_STDLIB_DOC_FILES[@]}"; do
        if [[ ! -f "$stdlib_file" ]]; then
            missing_docs+=("stdlib["$(basename $stdlib_file)"]");
            break;
        fi
    done;
    if [[ "${#missing_docs[@]}" -ne 0 ]]; then
        warning "Missing documentation:" "${missing_docs[@]}";
        echo "This is likely related to Zig issue #9158: https://github.com/ziglang/zig/issues/9158" >&2;
        echo "Essentially, the docs locations are inconsistent across platofrms and builds." >&2;
        echo "This is especially true on non-linux platforms (and non x86_64)" >&2;
        echo "" >&2;
        echo "This will not impact execution, and you can always use the website docs: https://ziglang.org/documentation/master/" >&2;
    fi
}

package() {
  cd "${srcdir}/zig-linux-${CARCH}-${pkgver//_/-}"
  install -d "${pkgdir}/usr/bin"
  install -d "${pkgdir}/usr/lib/zig"
  cp -R lib "${pkgdir}/usr/lib/zig/lib"
  install -D -m755 zig "${pkgdir}/usr/lib/zig/zig"
  ln -s /usr/lib/zig/zig "${pkgdir}/usr/bin/zig"
  # Already gave warnings above, just silently ignore here
  if [[ -f "docs/langref.html" ]]; then
    install -D -m644 docs/langref.html "${pkgdir}/usr/share/doc/zig/langref.html"
  fi;
  if [[ -d "docs/std" ]]; then
    cp -R docs/std "${pkgdir}/usr/share/doc/zig/";
  fi
  install -D -m644 LICENSE "${pkgdir}/usr/share/licenses/zig/LICENSE"
}

function exit_cleanup {
  # Sanitization
  rm -rf "${srcdir}"
  rm -rf "${pkgdir}"
  msg2 'exit cleanup done'

  remove_deps
}

trap exit_cleanup EXIT
