# Pacman helper fuctions

## Check weather a list of packages are installed
# Parameters
#  - $1: list of packages (array of strings)
# Returns:
#  - 0: all packages are installed
#  - 1: at least one package is not installed
function has_packages() {
	packages=$1
	for package in "${packages[@]}"; do
		if ! pacman -Q "$package" >/dev/null 2>&1; then
			return 1
		fi
	done
	return 0
}

## Check weather all pacman packages synced (are up to date)
# Returns:
#  - 0: all packages are up to date
#  - 1: at least one package is not up to date
function are_packages_synced() {
	test -n "$(pacman -Qu)" && return 1 || return 0
}

## Echoes the version of a pacman package
# Parameters:
#  - $1: package name
function package_version() {
	pacman -Qi $1 | grep Version | awk '{print $3}'
}

## Checks if a version for a package is newer than the currently one installed
# Parameters:
#  - $1 package name
#  - $2 package version
# Returns:
#  - 0: the version is newer than the one currently installed or
#       if the package is not yet installed
#  - 1: the version is equal or older than the one installed
function is_version_newer() {
	package=$1
	required_version=$2
	installed_version=$(package_version $1)
	has_packages $package || return 0
	if [[ $(vercmp $required_version $installed_version) -eq 1 ]]; then
		return 0
	fi
	return 1
}

## Build and install a package from PKGBUILD
# Parameters:
#  - $1: package name in files/PKGBUILD/
# Returns
#  - 0: installed with success
#  otherwise build errored
function makepkg_task() {
	package=$1
	dir="./files/PKGBUILD/${package}"
	(
		cd $dir && makepkg -sicC --noconfirm
	)
	return $?
}

## Takes a PKGBUILD template and data generates PKGBUILD
# Parameters:
#  - $1: package name in files/PKGBUILD/
#  - $2: template name in files/PKGBUILD/ (e.g: PKGBUILD.in)
#  - $3: json object with key-value pairs to replace in template
function makepkg_PKGBUILD() {
	package=$1
	template=$2
	data=$3
	(
		cd ./files/PKGBUILD/${package}
		cp $template PKGBUILD
		jq -r 'to_entries[] | "\(.key)=\(.value)"' <<<"$data" |
			while IFS='=' read -r key value; do
				stripped=$(echo $value | sed 's/^"//' | sed 's/"$//')
				echo "key: $key - value: $stripped"
				sed -i "s/{{$key}}/$stripped/g" PKGBUILD
			done
	)
}
