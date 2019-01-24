.PHONY: submodules permissions

submodules:
	git submodule init
	git submodule update

permissions:
	mkdir -p deploy
	chmod 777 deploy

