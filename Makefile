.PHONY: run build homedir
all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

reqs: STEAM_USERNAME STEAM_PASSWORD STEAM_GSLT IP PORT STEAM_GID TAG IP HOMEDIR CS_GAME_MODE CS_GAME_TYPE CS_INITIAL_MAP CS_MAP_GROUP

run: reqs rm homedir rundocker

install: reqs rm homedir installdocker

rundocker:
	$(eval NAME := $(shell cat NAME))
	$(eval HOMEDIR := $(shell cat HOMEDIR))
	$(eval TAG := $(shell cat TAG))
	$(eval IP := $(shell cat IP))
	$(eval PORT := $(shell cat PORT))
	$(eval STEAM_USERNAME := $(shell cat STEAM_USERNAME))
	$(eval STEAM_PASSWORD := $(shell cat STEAM_PASSWORD))
	$(eval STEAM_GID := $(shell cat STEAM_GID))
	$(eval STEAM_GSLT := $(shell cat STEAM_GSLT))
	$(eval CS_GAME_TYPE := $(shell cat CS_GAME_TYPE))
	$(eval CS_GAME_MODE := $(shell cat CS_GAME_MODE))
	$(eval CS_MAP_GROUP := $(shell cat CS_MAP_GROUP))
	$(eval CS_INITIAL_MAP := $(shell cat CS_INITIAL_MAP))
	@docker run --name=$(NAME) \
	-d \
	--cidfile="steamerCID" \
	--env USER=steam \
	--env STEAM_USERNAME=$(STEAM_USERNAME) \
	--env STEAM_PASSWORD=$(STEAM_PASSWORD) \
	--env STEAM_GID=$(STEAM_GID) \
	--env STEAM_GSLT=$(STEAM_GSLT) \
	--env STEAM_GUARD_CODE=$(STEAM_GUARD_CODE) \
	--env IP=$(IP) \
	--env PORT=$(PORT) \
	--env CS_GAME_TYPE=$(CS_GAME_TYPE) \
	--env CS_GAME_MODE=$(CS_GAME_MODE) \
	--env CS_MAP_GROUP=$(CS_MAP_GROUP) \
	--env CS_INITIAL_MAP=$(CS_INITIAL_MAP) \
	-p $(IP):26901:26901/udp \
	-p $(IP):27005:27005/udp \
	-p $(IP):27020:27020/udp \
	-p $(IP):$(PORT):$(PORT) \
	-p $(IP):$(PORT):$(PORT)/udp \
	-v $(HOMEDIR):/home/steam \
	-t $(TAG)

installdocker:
	$(eval NAME := $(shell cat NAME))	
	$(eval HOMEDIR := $(shell cat HOMEDIR))	
	$(eval TAG := $(shell cat TAG))
	$(eval IP := $(shell cat IP))
	$(eval PORT := $(shell cat PORT))
	$(eval STEAM_USERNAME := $(shell cat STEAM_USERNAME))
	$(eval STEAM_PASSWORD := $(shell cat STEAM_PASSWORD))
	$(eval STEAM_GID := $(shell cat STEAM_GID))
	$(eval STEAM_GSLT := $(shell cat STEAM_GSLT))
	$(eval CS_GAME_TYPE := $(shell cat CS_GAME_TYPE))
	$(eval CS_GAME_MODE := $(shell cat CS_GAME_MODE))
	$(eval CS_MAP_GROUP := $(shell cat CS_MAP_GROUP))
	$(eval CS_INITIAL_MAP := $(shell cat CS_INITIAL_MAP))
	@docker run --name=steamer \
	-d \
	--cidfile="steamerCID" \
	--env USER=steam \
	--env STEAM_USERNAME=$(STEAM_USERNAME) \
	--env STEAM_PASSWORD=$(STEAM_PASSWORD) \
	--env STEAM_GID=$(STEAM_GID) \
	--env STEAM_GSLT=$(STEAM_GSLT) \
	--env STEAM_GUARD_CODE=$(STEAM_GUARD_CODE) \
	--env IP=$(IP) \
	--env PORT=$(PORT) \
	--env CS_GAME_TYPE=$(CS_GAME_TYPE) \
	--env CS_GAME_MODE=$(CS_GAME_MODE) \
	--env CS_MAP_GROUP=$(CS_MAP_GROUP) \
	--env CS_INITIAL_MAP=$(CS_INITIAL_MAP) \
	-p $(IP):26901:26901/udp \
	-p $(IP):27005:27005/udp \
	-p $(IP):$(PORT):$(PORT) \
	-p $(IP):$(PORT):$(PORT)/udp \
	-p $(IP):27020:27020/udp \
	-v $(HOMEDIR):/home/steam \
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

STEAM_GSLT:
	@while [ -z "$$STEAM_GSLT" ]; do \
		read -r -p "Enter the steam GSLT you wish to associate with this container [STEAM_GSLT]: " STEAM_GSLT; echo "$$STEAM_GSLT">>STEAM_GSLT; cat STEAM_GSLT; \
	done ;

STEAM_PASSWORD:
	@while [ -z "$$STEAM_PASSWORD" ]; do \
		read -r -p "Enter the steam password you wish to associate with this container [STEAM_PASSWORD]: " STEAM_PASSWORD; echo "$$STEAM_PASSWORD">>STEAM_PASSWORD; cat STEAM_PASSWORD; \
	done ;

IP:
	@while [ -z "$$IP" ]; do \
		read -r -p "Enter the IP Address you wish to assign to this container [IP]: " IP; echo "$$IP">>IP; cat IP; \
	done ;

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the PORT Address you wish to assign to this container (27015) [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;

CS_GAME_TYPE:
	@while [ -z "$$CS_GAME_TYPE" ]; do \
		read -r -p "Enter the CS_GAME_TYPE Address you wish to assign to this container [CS_GAME_TYPE]: " CS_GAME_TYPE; echo "$$CS_GAME_TYPE">>CS_GAME_TYPE; cat CS_GAME_TYPE; \
	done ;

CS_GAME_MODE:
	@while [ -z "$$CS_GAME_MODE" ]; do \
		read -r -p "Enter the CS_GAME_MODE Address you wish to assign to this container [CS_GAME_MODE]: " CS_GAME_MODE; echo "$$CS_GAME_MODE">>CS_GAME_MODE; cat CS_GAME_MODE; \
	done ;

CS_MAP_GROUP:
	@while [ -z "$$CS_MAP_GROUP" ]; do \
		read -r -p "Enter the CS_MAP_GROUP Address you wish to assign to this container (mg_demolition) [CS_MAP_GROUP]: " CS_MAP_GROUP; echo "$$CS_MAP_GROUP">>CS_MAP_GROUP; cat CS_MAP_GROUP; \
	done ;

CS_INITIAL_MAP:
	@while [ -z "$$CS_INITIAL_MAP" ]; do \
		read -r -p "Enter the CS_INITIAL_MAP Address you wish to assign to this container (de_lake) [CS_INITIAL_MAP]: " CS_INITIAL_MAP; echo "$$CS_INITIAL_MAP">>CS_INITIAL_MAP; cat CS_INITIAL_MAP; \
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
