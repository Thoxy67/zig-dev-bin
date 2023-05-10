# Contributor: Thoxy <thi.hur67@gmail.com>

pkgname=zig-dev-bin
epoch=1
pkgver=0.11.0_dev.3041+8e9c9f6fd
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
ZIG_MINISIGN_KEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"

# Prints a warning message to stderr
warning() {
	echo -en "\e[33;1mWARNING\e[0m: " >&2
	echo "$@" >&2
}

pkgver() {
	local index_file="${srcdir}/zig-version-index.json"
	# Invalidate old verison-index.json
	#
	# If we put version-index in `source` then it would be cached...
	if [[ -x "$index_file" ]]; then
		rm "$index_file"
	fi
	curl -sS "https://ziglang.org/download/index.json" -o "$index_file"
	jq -r .master.version "$index_file" | sed 's/-/_/'
}

prepare() {
	local newver="$(pkgver)"
	pushd "${srcdir}" >/dev/null
	local index_file="zig-version-index.json"
	local newurl="$(jq -r ".master.\"${CARCH}-linux\".tarball" $index_file)"
	local newurl_sig="$newurl.minisig"
	local newfile="zig-linux-${CARCH}-${newver}.tar.xz"
	local newfile_sig="$newfile.minisig"
	source+=("${newfile}:${newurl}" "${newfile_sig}:${newurl_sig}")
	local expected_hash="$(jq -r ".master.\"${CARCH}-linux\".shasum" "$index_file")"
	sha256sums+=("$expected_hash" "SKIP")
	if [[ -f "$newfile" && -f "$newfile_sig" ]]; then
		echo "Reusing existing $newfile (and signature)"
	else
		echo "Downloading Zig $newver from $newurl"
		curl -Ss "$newurl" -o "$newfile"
		echo "Downloading signature..."
		curl -Ss "$newurl_sig" -o "$newfile_sig"
	fi
	echo "" >&2
	local actual_hash="$(sha256sum "$newfile" | grep -oE '^\w+')"
	if [[ "$expected_hash" != "$actual_hash" ]]; then
		echo "ERROR: Expected hash $expected_hash for $newfile, but got $actual_hash" >&2
		exit 1
	fi
	echo "Using minisign to check signature"
	if ! minisign -V -P "$ZIG_MINISIGN_KEY" -m "$newfile" -x "$newfile_sig"; then
		echo "ERROR: Failed to check signature for $newfile" >&2
		exit 1
	fi
	echo "Extracting file"
	tar -xf "$newfile"
	popd >/dev/null
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
	fi
	if [[ -d "docs/std" ]]; then
		cp -R docs/std "${pkgdir}/usr/share/doc/zig/"
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
