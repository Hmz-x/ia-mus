#!/bin/sh

# Program Data
PROGRAM="$(basename "$0")"
LICENSE="GNU GPLv3"
VERSION="1.0"
AUTHOR="Hamza Kerem Mumcu"
USAGE="Usage: 
$PROGRAM dl IDENTIFIER [DEST_DIR]
$PROGRAM up ARTIST PROJECT DIR"

err(){
	# Print error message, "$1", to stderr and exit.
	printf "%s. Exitting.\n" "$1" >&2
	exit 1
}

show_help(){
	# Print program usage.
	printf "%s\n" "$USAGE"	
	exit 0
}

show_version(){
	# Print program version info.
	printf "%s\n" "$PROGRAM $VERSION"
	printf "Licensed under %s\n" "$LICENSE"
	printf "Written by %s\n" "$AUTHOR"
	exit 0
}

# Download Music 
download_dir()
{
	shift
	identifier="$1"
	[ -z "$identifier" ] && err "See usage"
	
	# Set destination directory if passed as parameter
	if [ -n "$2" ]; then
		dest_dir="$2"
		[ ! -d "$dest_dir" ] && mkdir -p "$dest_dir"

		ia download "$identifier" --glob="*.mp3" --no-directories --destdir="$dest_dir"
	else
		ia download "$identifier" --glob="*.mp3"
	fi
}

# Download Music 
upload_dir()
{
	shift
	artist="$1"
	project="$2"
	dir="$3"
	(($# != 3)) && err "See usage"

	identifier="$(echo "${artist}-${project}" | tr " " "-")"
	
	ia upload $identifier "$dir"/* --metadata="mediatype:audio" \
		--metadata="creator:${artist}" --metadata="subject:${artist},${project}" \
		--metadata="title:${artist} - ${project}"
}

parse_opts(){
	case "$1" in
		-h|--help) show_help;;
		-v|--version) show_version;;
		up) upload_dir "$@";;	
		dl) download_dir "$@";;
		*) err "Unknown option. Please see '--help'.";;
	esac
}

parse_opts "$@"
