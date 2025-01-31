default:
    @just --list --unsorted

config := absolute_path('config')
build := absolute_path('.build')
out := absolute_path('firmware')
draw := absolute_path('draw')

# parse build.yaml and filter targets by expression
_parse_targets $expr:
    #!/usr/bin/env bash
    yq -r '
      (.include // [])[] 
      | [
          (.board // ""), 
          (.shield // ""), 
          (."artifact-name" // ""), 
          (.snippet // ""), 
          (."cmake-args" // "")
        ] 
      | join(",")
    ' build.yaml \
    | grep -v "^," \
    | grep -i "${expr/#all/.*}"

# build firmware for single board & shield combination
_build_single $board $shield $artifact_name $snippet $cmake_args *west_args:
    #!/usr/bin/env bash
    set -euo pipefail
    build_dir="{{ build / '$artifact_name' }}"

    echo "Building firmware for $artifact_name..."
    echo west build -s zmk/app -d "$build_dir" -b $board {{ west_args }} ${snippet:+-S "$snippet"} -- \
    -DZMK_CONFIG="{{ config }}" ${shield:+-DSHIELD="$shield"} ${cmake_args}
    west build -s zmk/app -d "$build_dir" -b $board {{ west_args }} ${snippet:+-S "$snippet"} -- \
    -DZMK_CONFIG="{{ config }}" ${shield:+-DSHIELD="$shield"} ${cmake_args}

    if [[ -f "$build_dir/zephyr/zmk.uf2" ]]; then
    mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.uf2" "{{ out }}/$artifact_name.uf2"
    else
    mkdir -p "{{ out }}" && cp "$build_dir/zephyr/zmk.bin" "{{ out }}/$artifact_name.bin"
    fi

# build firmware for matching targets
build expr *west_args:
    #!/usr/bin/env bash
    set -euo pipefail
    targets=$(just _parse_targets {{ expr }})

    [[ -z $targets ]] && echo "No matching targets found. Aborting..." >&2 && exit 1
    echo "$targets" | while IFS=, read -r board shield artifact_name snippet cmake_args; do
    just _build_single "$board" "$shield" "$artifact_name" "$snippet" "$cmake_args" {{ west_args }}
    done

# clear build cache and artifacts
clean:
    rm -rf {{ build }} {{ out }}

# clear all automatically generated files
clean-all: clean
    rm -rf .west zmk

# parse & plot keymap
draw:
    #!/usr/bin/env bash
    set -euo pipefail
    nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/kyria_rev3.keymap" > assets/kyria_rev3.keymap.yaml
    nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml draw assets/kyria_rev3.keymap.yaml --qmk-keyboard=splitkb/kyria/rev3" > assets/kyria_rev3.svg
    nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/splitkb_aurora_corne.keymap" > assets/aurora_corne_v1.keymap.yaml
    nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml draw assets/aurora_corne_v1.keymap.yaml --qmk-keyboard=splitkb/aurora/corne/rev1" > assets/aurora_corne_v1.svg

# initialize west
init:
    west init -l config
    west update --fetch-opt=--filter=blob:none
    west zephyr-export

# list build targets
list:
    @just _parse_targets all | sed 's/,*$//' | sort | column

# update west
update:
    west update --fetch-opt=--filter=blob:none

# upgrade zephyr-sdk and python dependencies
upgrade-sdk:
    nix flake update --flake .
