.PHONY: clean init update devshell

clean:
	rm -rf openwrt

init:
	git clone --branch openwrt-23.05 https://github.com/openwrt/openwrt.git
	git clone https://github.com/chirpstack/chirpstack-openwrt-config.git openwrt/env
	cp feeds.conf.default openwrt/feeds.conf.default
	docker-compose run --rm chirpstack-gateway-os scripts/feeds update -a
	docker-compose run --rm chirpstack-gateway-os scripts/feeds install -a


update:
	cd openwrt && git pull
	docker-compose run --rm chirpstack-gateway-os scripts/feeds update -a
	docker-compose run --rm chirpstack-gateway-os scripts/feeds install -a

devshell:
	docker-compose run --rm chirpstack-gateway-os bash
