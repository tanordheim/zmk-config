.PHONY: keymap-images
keymap-images:
	keymap parse -c 10 -z config/splitkb_aurora_sofle.keymap > assets/splitkb_aurora_sofle.keymap.yaml
	keymap draw assets/splitkb_aurora_sofle.keymap.yaml --qmk-keyboard splitkb/aurora/sofle_v2/rev1 > assets/splitkb_aurora_sofle.svg
