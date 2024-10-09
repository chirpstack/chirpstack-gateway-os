.PHONY: build clean init update devshell show-envs switch-env

# Build the OpenWrt image.
# Note: execute this within the devshell.
build:
	cd openwrt && make

# Initialize the OpenWrt environment.
init:
	git submodule init
	git submodule update
	cp feeds.conf.default openwrt/feeds.conf.default
	ln -s ../conf/.config openwrt/.config
	ln -s ../conf/files openwrt/files
	docker compose run --rm chirpstack-gateway-os openwrt/scripts/feeds update -a
	docker compose run --rm chirpstack-gateway-os openwrt/scripts/feeds install -a
	docker compose run --rm chirpstack-gateway-os quilt init

# Update OpenWrt + package feeds.
update:
	git submodule update
	cp feeds.conf.default openwrt/feeds.conf.default
	cd openwrt && \
		./scripts/feeds update -a && \
		./scripts/feeds install -a

# Activate the devshell.
devshell:
	docker compose run --rm chirpstack-gateway-os bash

# Switch configuration environment.,
# Note: execute this within the devshell.
switch-env:
	@echo "Rollback previously applied patches"
	-cd openwrt && quilt pop -a

	@echo "Switching configuration"
	rm -f conf/files conf/patches conf/.config
	ln -s ${ENV}/files conf/files
	ln -s ${ENV}/patches conf/patches
	ln -s ${ENV}/.config conf/.config

	@echo "Applying patches"
	cd openwrt && quilt push -a

# Clean the OpenWrt environment.
clean:
	rm -rf openwrt
