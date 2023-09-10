.PHONY: keymap-images
keymap-images: corne-keymap-image sofle-keymap-image

.PHONY: corne-keymap-image
corne-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/corne.keymap > assets/corne.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/corne.keymap.yaml --qmk-keyboard=crkbd/rev1 --qmk-layout=LAYOUT_split_3x6_3 > assets/corne.svg

.PHONY: sofle-keymap-image
sofle-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/splitkb_aurora_sofle.keymap > assets/splitkb_aurora_sofle.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/splitkb_aurora_sofle.keymap.yaml --qmk-keyboard=splitkb/aurora/sofle_v2/rev1 > assets/splitkb_aurora_sofle.svg

.PHONY: zmk-local-setup
zmk-local-setup:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west init -l app/
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west update
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" zmkfirmware/zmk-build-arm:stable west zephyr-export

.PHONY: corne
corne: corne-left corne-right

.PHONY: corne-left
corne-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=corne_left -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: corne_right
corne-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=corne_right -DZMK_CONFIG="/my-zmk-config/config"
