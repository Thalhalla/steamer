.PHONY: run build homedir
all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

reqs: STEAM_USERNAME STEAM_PASSWD STEAM_GLST IP STEAM_GID TAG IP HOMEDIR

run: rm reqs homedir rundocker

install: rm reqs homedir installdocker

rundocker:
	$(eval NAME := $(shell cat NAME))	
	$(eval HOMEDIR := $(shell cat HOMEDIR))	
	$(eval TAG := $(shell cat TAG))
	$(eval IP := $(shell cat IP))
	$(eval STEAM_USERNAME := $(shell cat STEAM_USERNAME))
	$(eval STEAM_PASSWORD := $(shell cat STEAM_PASSWORD))
	$(eval STEAM_GID := $(shell cat STEAM_GID))
	$(eval STEAM_GLST := $(shell cat STEAM_GLST))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	-d \
	--cidfile="steamerCID" \
	--env USER=steam \
	--env STEAM_USERNAME=$(STEAM_USERNAME) \
	--env STEAM_PASSWORD=$(STEAM_PASSWORD) \
	--env STEAM_GID=$(STEAM_GID) \
	--env STEAM_GLST=$(STEAM_GLST) \
	--env STEAM_GUARD_CODE=$(STEAM_GUARD_CODE) \
	--env IP=$(IP) \
	-p $(IP):26901:26901/udp \
	-p $(IP):27005:27005/udp \
	-p $(IP):27015:27015 \
	-p $(IP):27015:27015/udp \
	-p $(IP):27020:27020/udp \
	-v $(HOMEDIR)/.local:/home/steam/.steam \
	-v $(HOMEDIR)/.steam:/home/steam/.local \
	-v $(HOMEDIR)/Steam:/home/steam/steamcmd \
	-v $(HOMEDIR)/Steam:/home/steam/Steam \
	-v $(HOMEDIR)/SteamLibrary:/home/steam/SteamLibrary \
	-v $(HOMEDIR)/serverfiles:/home/steam/serverfiles \
	-v $(HOMEDIR)/log:/home/steam/log \
	-t $(TAG)

installdocker:
	$(eval NAME := $(shell cat NAME))	
	$(eval HOMEDIR := $(shell cat HOMEDIR))	
	$(eval TAG := $(shell cat TAG))
	$(eval IP := $(shell cat IP))
	$(eval STEAM_USERNAME := $(shell cat STEAM_USERNAME))
	$(eval STEAM_PASSWORD := $(shell cat STEAM_PASSWORD))
	$(eval STEAM_GID := $(shell cat STEAM_GID))
	$(eval STEAM_GLST := $(shell cat STEAM_GLST))
	chmod 777 $(TMP)
	@docker run --name=steamer \
	-d \
	--cidfile="steamerCID" \
	--env USER=steam \
	--env STEAM_USERNAME=$(STEAM_USERNAME) \
	--env STEAM_PASSWORD=$(STEAM_PASSWORD) \
	--env STEAM_GID=$(STEAM_GID) \
	--env STEAM_GLST=$(STEAM_GLST) \
	--env STEAM_GUARD_CODE=$(STEAM_GUARD_CODE) \
	--env IP=$(IP) \
	-p $(IP):26901:26901/udp \
	-p $(IP):27005:27005/udp \
	-p $(IP):27015:27015 \
	-p $(IP):27015:27015/udp \
	-p $(IP):27020:27020/udp \
	-v $(HOMEDIR)/.local:/home/steam/.steam \
	-v $(HOMEDIR)/.steam:/home/steam/.local \
	-v $(HOMEDIR)/Steam:/home/steam/steamcmd \
	-v $(HOMEDIR)/Steam:/home/steam/Steam \
	-v $(HOMEDIR)/SteamLibrary:/home/steam/SteamLibrary \
	-v $(HOMEDIR)/serverfiles:/home/steam/serverfiles \
	-v $(HOMEDIR)/log:/home/steam/log \
	-t $(TAG) /bin/bash

builddocker:
	$(eval TAG := $(shell cat TAG))	
	/usr/bin/time -v docker build -t $(TAG) .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	-@docker kill `cat steamerCID`

rm-image:
	-@docker rm `cat steamerCID`
	-@rm steamerCID

rm: kill rm-image

clean:  rm

logs:
	docker logs  -f `cat steamerCID`

enter:
	docker exec -i -t `cat steamerCID` /bin/bash

HOMEDIR:
	@while [ -z "$$HOMEDIR" ]; do \
		read -r -p "Enter the HOMEDIR you wish to associate with this container [HOMEDIR]: " HOMEDIR; echo "$$HOMEDIR">>HOMEDIR; cat HOMEDIR; \
	done ;

STEAM_USERNAME:
	@while [ -z "$$STEAM_USERNAME" ]; do \
		read -r -p "Enter the steam username you wish to associate with this container [STEAM_USERNAME]: " STEAM_USERNAME; echo "$$STEAM_USERNAME">>STEAM_USERNAME; cat STEAM_USERNAME; \
	done ;

STEAM_GUARD_CODE:
	@while [ -z "$$STEAM_GUARD_CODE" ]; do \
		read -r -p "Enter the steam guard code you wish to associate with this container [STEAM_GUARD_CODE]: " STEAM_GUARD_CODE; echo "$$STEAM_GUARD_CODE">>STEAM_GUARD_CODE; cat STEAM_GUARD_CODE; \
	done ;

STEAM_GID:
	@while [ -z "$$STEAM_GID" ]; do \
		read -r -p "Enter the steam game id you wish to associate with this container [STEAM_GID]: " STEAM_GID; echo "$$STEAM_GID">>STEAM_GID; cat STEAM_GID; \
	done ;

STEAM_GLST:
	@while [ -z "$$STEAM_GLST" ]; do \
		read -r -p "Enter the steam glst you wish to associate with this container [STEAM_GLST]: " STEAM_GLST; echo "$$STEAM_GLST">>STEAM_GLST; cat STEAM_GLST; \
	done ;

STEAM_PASSWORD:
	@while [ -z "$$STEAM_PASSWORD" ]; do \
		read -r -p "Enter the steam password you wish to associate with this container [STEAM_PASSWORD]: " STEAM_PASSWORD; echo "$$STEAM_PASSWORD">>STEAM_PASSWORD; cat STEAM_PASSWORD; \
	done ;

IP:
	@while [ -z "$$IP" ]; do \
		read -r -p "Enter the IP Address you wish to assign to this container [IP]: " IP; echo "$$IP">>IP; cat IP; \
	done ;

homedir: HOMEDIR
	$(eval HOMEDIR := $(shell cat HOMEDIR))
	-@sudo mkdir -p $(HOMEDIR)/SteamLibrary/steamapps
	-@sudo mkdir -p $(HOMEDIR)/Steam
	-@sudo mkdir -p $(HOMEDIR)/steamcmd
	-@sudo mkdir -p $(HOMEDIR)/.steam
	-@sudo mkdir -p $(HOMEDIR)/.local
	-@sudo chown -R 1000:1000 $(HOMEDIR)

csgo:
	echo '440'>STEAM_GID

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)
