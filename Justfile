default:
    @just --list --unsorted

config := absolute_path('config')
module := absolute_path('config/zmk-local-module')
build := absolute_path('.build')
out := absolute_path('firmware')

# parse combos.dtsi and adjust settings to not run out of slots
_parse_combos:
    #!/usr/bin/env bash
    set -euo pipefail
    cconf="{{ config / 'combos.dtsi' }}"
    if [[ -f $cconf ]]; then
        echo "Combos are auto-calculated; no config updates needed."
    fi

# parse build.yaml and filter targets by expression
_parse_targets $expr:
    #!/usr/bin/env bash
    attrs="[.board, .shield, .snippet]"
    filter=".include[] | [.board, .shield] | join(\",\")"
    echo "$(yq -r "$filter" build.yaml | grep -i "${expr/#all/.*}")"

# build firmware for single board & shield combination
_build_single $board $shield $snippet *west_args:
    #!/usr/bin/env bash
    set -euo pipefail
    artifact="${shield:+$shield-}${board}"
    build_dir="{{ build / '$artifact' }}"

    echo "Building firmware for $artifact..."
    west build -s zmk/app -d "$build_dir" -b $board {{ west_args }} ${snippet:+-S "$snippet"} -- \
        ${shield:+-DSHIELD="$shield"} \
        -DZMK_EXTRA_MODULES="{{ module }}" \
        -DZMK_CONFIG="{{ config }}" \

    if [[ -f "$build_dir/zephyr/zmk.uf2" ]]; then
        mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.uf2" "{{ out }}/$artifact.uf2"
    else
        mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.bin" "{{ out }}/$artifact.bin"
    fi

# build firmware for matching targets
build expr *west_args: _parse_combos
    #!/usr/bin/env bash
    set -euo pipefail
    targets=$(just _parse_targets {{ expr }})

    [[ -z $targets ]] && echo "No matching targets found. Aborting..." >&2 && exit 1
    echo "$targets" | while IFS=, read -r board shield snippet; do
        just _build_single "$board" "$shield" "$snippet" {{ west_args }}
    done

# clear build cache and artifacts
clean:
    rm -rf {{ build }} {{ out }}

# initialize west
init:
    west init -l config
    west update
    west zephyr-export

# update west
update:
    west update

# list build targets
list:
    @just _parse_targets all | sed 's/,$//' | sort | column
