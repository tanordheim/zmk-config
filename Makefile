.PHONY: keymap-images
keymap-images: corne-keymap-image sofle-keymap-image kyria-keymap-image

.PHONY: corne-keymap-image
corne-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/corne.keymap > assets/corne.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/corne.keymap.yaml --qmk-keyboard=crkbd/rev1 --qmk-layout=LAYOUT_split_3x6_3 > assets/corne.svg

.PHONY: sofle-keymap-image
sofle-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/splitkb_aurora_sofle.keymap > assets/splitkb_aurora_sofle.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/splitkb_aurora_sofle.keymap.yaml --qmk-keyboard=splitkb/aurora/sofle_v2/rev1 > assets/splitkb_aurora_sofle.svg

.PHONY: kyria-keymap-image
kyria-keymap-image:
	keymap --config=keymap_drawer.config.yaml parse --columns=10 --zmk-keymap=config/kyria_rev3.keymap > assets/kyria_rev3.keymap.yaml
	keymap --config=keymap_drawer.config.yaml draw assets/kyria_rev3.keymap.yaml --qmk-keyboard=splitkb/kyria/rev3 > assets/kyria_rev3.svg

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

.PHONY: corne-right
corne-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=corne_right -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: kyria
kyria: kyria-left kyria-right

.PHONY: kyria-left
kyria-left:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/left -- -DSHIELD=kyria_rev3_left -DZMK_CONFIG="/my-zmk-config/config"

.PHONY: kyria-right
kyria-right:
	docker run -w /zmk -v "${PWD}/../zmk:/zmk" -v "${PWD}:/my-zmk-config" zmkfirmware/zmk-build-arm:stable west build -s app -b nice_nano_v2 -d build/right -- -DSHIELD=kyria_rev3_right -DZMK_CONFIG="/my-zmk-config/config"
