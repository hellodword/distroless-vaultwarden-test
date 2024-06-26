#! /usr/bin/env bash

_resolve_dependencies() {
    local prog_path=$1
    local seen_libs=$2

    local libs=$(ldd "$prog_path" | grep -oP '(?<=\s)/lib(64)?[^ \t]+')

    for lib in $libs; do
        if [[ ! "$seen_libs" =~ "$lib" ]]; then
            lib="$(realpath $lib)"
            seen_libs="$seen_libs $lib"
            echo "$lib"
            _resolve_dependencies "$lib" "$seen_libs"
        fi
    done
}

_resolve_dependencies "$1" | sort -u | sed -E 's/\.so(\.[0-9]+)+$//'
