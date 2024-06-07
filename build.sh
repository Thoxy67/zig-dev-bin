#!/bin/bash

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

echo -e "\n⚡ \e[1mzig-dev-bin\e[0m Archlinux PKGBUILD builder\n"

if ! command -v pacman >/dev/null 2>&1; then
	echo -e "\033[1;31mError:\033[0m \e[1mThis script is only intended for \e[1mArch Linux\e[0m systems. ❤️" >&2
	exit 1
fi

show_help() {
	echo "Usage: $0 [-f, --force] [-y, --yes] [-h, --help]"
	echo -e "\t-f, --force\tForce the installation/update"
	echo -e "\t-y, --yes\tDo not ask for confirmation"
	echo -e "\t-h, --help\tPrint help"
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	-f | --force) force=1 ;;
	-y | --yes) yes=1 ;;
	-h | --help)
		show_help
		exit 0
		;;
	*)
		echo "Unknown option: $1"
		show_help
		exit 1
		;;
	esac
	shift
done

clean() {
	echo -e "🧹 Clean up install files..."
	rm -rf "$PWD/zig_install_tmp" "$PWD/zig-dev-bin-*.tar.zst" "$PWD/pkg"
}

succeed() {
	echo ""
	sleep 2
	clean
	echo "✔️  Installation succeeded"
	exit 0
}

abort() {
	echo ""
	sleep 2
	clean
	echo -e "❌ Installation aborted !"
	exit 1
}

install_zig() {
	trap abort SIGINT
	if [[ "$yes" != 1 ]]; then
		read -r -p "📦 Do you want to install/update Zig? (Y/n) " -i "y" answer
		answer="${answer:-y}"
		answer="${answer,,}"
	else
		answer="y"
	fi
	if [[ "$answer" =~ ^[Yy]$ ]]; then
		if [[ ! -f "PKGBUILD" ]]; then
			mkdir "$PWD/zig_install_tmp" && (cd "$PWD/zig_install_tmp" || abort)
			wget -q "https://raw.githubusercontent.com/Thoxy67/zig-dev-bin/main/PKGBUILD" -O "$PWD/PKGBUILD"
		fi
		makepkg -si --noconfirm
		cd .. || exit
		succeed
	else
		exit 0
	fi
}

json=$(curl -s https://ziglang.org/download/index.json)
version=$(echo "$json" | jq -r '.master.version' | tr '-' '_')

echo "Latest Zig version: v$version"
if command -v zig >/dev/null; then
	installed=$(zig version | tr '-' '_')
	echo -e "Installed Zig Version: \e[1mv$installed\e[0m"
	if [[ "$installed" == "$version" ]]; then
		echo -e "\n\e[0;42mYou have the latest Zig version installed on your machine\033[0m"
		[[ "$force" ]] && install_zig || echo -e "\033[36mTo force install, pass the argument: \e[0m--force\n"
	else
		echo -e "\n\e[33m🆕 A new Zig version (v$version) is available!\e[0m\n"
		install_zig
	fi
else
	echo -e "\e[0;43mZig is not installed on your computer.\e[0m\n"
	install_zig
fi
