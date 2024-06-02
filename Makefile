.PHONY: keymap-images
keymap-images: splitkb-aurora-corne-keymap-image splitkb-aurora-sofle-keymap-image kyria-v3-keymap-image

.PHONY: clean
clean:
	rm -rf ~/Code/zmk/build/left/*
	rm -rf ~/Code/zmk/build/right/*

.PHONY: splitkb-aurora-corne-keymap-image
splitkb-aurora-corne-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/splitkb_aurora_corne.keymap > assets/splitkb_aurora_corne.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/splitkb_aurora_corne.keymap.yaml --qmk-keyboard=splitkb/aurora/corne/rev1 --qmk-layout=LAYOUT_split_3x6_3 > assets/splitkb_aurora_corne.svg

.PHONY: splitkb-aurora-sofle-keymap-image
splitkb-aurora-sofle-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/splitkb_aurora_sofle.keymap > assets/splitkb_aurora_sofle.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/splitkb_aurora_sofle.keymap.yaml --qmk-keyboard=splitkb/aurora/sofle_v2/rev1 > assets/splitkb_aurora_sofle.svg

.PHONY: kyria-v3-keymap-image
kyria-v3-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/kyria_rev3.keymap > assets/kyria_rev3.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/kyria_rev3.keymap.yaml --qmk-keyboard=splitkb/kyria/rev3 > assets/kyria_rev3.svg

.PHONY: zmk-local-setup
zmk-local-setup:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west init -l app/
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west update
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west zephyr-export

.PHONY: splitkb-aurora-corne
splitkb-aurora-corne: clean splitkb-aurora-corne-left splitkb-aurora-corne-right

.PHONY: splitkb-aurora-corne-left
splitkb-aurora-corne-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=splitkb_aurora_corne_left -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: splitkb-aurora-corne-right
splitkb-aurora-corne-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=splitkb_aurora_corne_right -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: splitkb-aurora-sofle
splitkb-aurora-sofle: clean splitkb-aurora-sofle-left splitkb-aurora-sofle-right

.PHONY: splitkb-aurora-sofle-left
splitkb-aurora-sofle-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=splitkb_aurora_sofle_left -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: splitkb-aurora-sofle-right
splitkb-aurora-sofle-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=splitkb_aurora_sofle_right -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: kyria
kyria: clean kyria-left kyria-right

.PHONY: kyria-left
kyria-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=kyria_rev3_left -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: kyria-right
kyria-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=kyria_rev3_right -DZMK_CONFIG="/my-zmk-config/config"
