.PHONY: keymap-images
keymap-images: kyria-v3-keymap-image

.PHONY: clean
clean:
	rm -rf ~/Code/zmk/build/left/*
	rm -rf ~/Code/zmk/build/right/*

.PHONY: kyria-v3-keymap-image
kyria-v3-keymap-image:
	nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/kyria_rev3.keymap" > assets/kyria_rev3.keymap.yaml
	nix-shell -p pipx --run "pipx run keymap-drawer --config=keymap_drawer.config.yaml draw assets/kyria_rev3.keymap.yaml --qmk-keyboard=splitkb/kyria/rev3" > assets/kyria_rev3.svg

.PHONY: zmk-local-setup
zmk-local-setup:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable sh -c "(git config --global safe.directory '*' && west init -l app/)"
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable sh -c "(git config --global safe.directory '*' && west update)"
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable sh -c "(git config --global safe.directory '*' && west zephyr-export)"

.PHONY: kyria-v3
kyria-v3: clean kyria-v3-left kyria-v3-right

.PHONY: kyria-v3-left
kyria-v3-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=kyria_rev3_left -DZMK_CONFIG="/my-zmk-config/config" -DEXTRA_CONF_FILE=/my-zmk-config/config/kyria_rev3_choc.conf
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=kyria_rev3_left -DZMK_CONFIG="/my-zmk-config/config" -DEXTRA_CONF_FILE=/my-zmk-config/config/kyria_rev3_mx.conf

.PHONY: kyria-v3-right
kyria-v3-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=kyria_rev3_right -DZMK_CONFIG="/my-zmk-config/config" -DEXTRA_CONF_FILE=/my-zmk-config/config/kyria_rev3_choc.conf
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=kyria_rev3_right -DZMK_CONFIG="/my-zmk-config/config" -DEXTRA_CONF_FILE=/my-zmk-config/config/kyria_rev3_mx.conf

