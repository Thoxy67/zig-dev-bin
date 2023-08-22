# Contributor: Thoxy <thi.hur67@gmail.com>

ZIG_VERSION_INDEX=$(curl -sS "https://ziglang.org/download/index.json")
pkgname=zig-dev-bin
epoch=1
pkgver=$( echo $ZIG_VERSION_INDEX | jq -r .master.version | sed 's/-/_/')
pkgrel=1
pkgdesc="A general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software"
arch=('x86_64' 'aarch64')
url="https://ziglang.org/"
license=('MIT')
makedepends=(curl jq minisign tar sed)
options=('!strip')
provides=('zig')
conflicts=('zig')
shasums=(
	'SKIP'
)

echo -e '  \e[93m                                     z'
echo -e '                                    zzz'
echo -e '                               zzzzzz\e[90m'
echo -e '  \e[90mzzzzzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzz'
echo -e '  \e[90mzzzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzz'
echo -e '  \e[90mzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzz'
echo -e '  \e[90mzzzzz                \e[93mzzzzzz      \e[90mzzzzz'
echo -e '  \e[90mzzzzz              \e[93mzzzzzz        \e[90mzzzzz'
echo -e '  \e[90mzzzzz            \e[93mzzzzzz          \e[90mzzzzz'
echo -e '  \e[90mzzzzz          \e[93mzzzzzz            \e[90mzzzzz'
echo -e '  \e[90mzzzzz        \e[93mzzzzzz              \e[90mzzzzz'
echo -e '  \e[90mzzzzz      \e[93mzzzzzz                \e[90mzzzzz'
echo -e '  \e[90mzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzz'
echo -e '  \e[90mzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzzzz'
echo -e '  \e[90mzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzzzzzz'
echo -e '     \e[93mzzzzzz'
echo -e '   zzz'
echo -e '  z\e[0m'

# https://ziglang.org/download/
ZIG_MINISIGN_KEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"

warning() {
	echo -en "\e[33;1mWARNING\e[0m: " >&2
	echo "$@" >&2
}

prepare() {
	pushd "${srcdir}" >/dev/null
	local newurl="$(echo $ZIG_VERSION_INDEX | jq -r ".master.\"${CARCH}-linux\".tarball")"
	local newurl_sig="$newurl.minisig"
	local newfile="zig-linux-${CARCH}-${newver}.tar.xz"
	local newfile_sig="$newfile.minisig"
	source+=("${newfile}:${newurl}" "${newfile_sig}:${newurl_sig}")
	local expected_hash="$(echo $ZIG_VERSION_INDEX | jq -r ".master.\"${CARCH}-linux\".shasum")"
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
