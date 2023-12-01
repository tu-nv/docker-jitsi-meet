FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= drl-loadbalancing
JITSI_REPO ?= nvantu
NATIVE_ARCH ?= $(shell uname -m)

include .env

# export all .env variable to sub Makefile
export $(shell sed 's/=.*//' .env)

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export PROGRESS_NO_TRUNC=1
# set this to see full command output while building
export BUILDKIT_PROGRESS=plain

JITSI_SERVICES := base base-java web prosody jicofo jvb jigasi jibri

ifeq ($(NATIVE_ARCH),x86_64)
	TARGETPLATFORM := linux/amd64
else ifeq ($(NATIVE_ARCH),aarch64)
	TARGETPLATFORM := linux/arm64
else
	TARGETPLATFORM := unsupported
endif

BUILD_ARGS := \
	--build-arg JITSI_REPO=$(JITSI_REPO) \
	--build-arg JITSI_RELEASE=$(JITSI_RELEASE)

ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS := $(BUILD_ARGS) --no-cache
endif


all: build-all

$(JITSI_SERVICES):
	docker-compose -f ./docker-compose.yml build $@
	docker push $(JITSI_REPO)/$@:$(JITSI_BUILD)

release:
	@$(foreach SERVICE, $(JITSI_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) buildx;)

buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--progress=plain \
		$(BUILD_ARGS) --build-arg BASE_TAG=$(JITSI_BUILD) \
		--pull --push \
		--tag $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD) \
		--tag $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_RELEASE) \
		$(JITSI_SERVICE)

$(addprefix buildx_,$(JITSI_SERVICES)):
	$(MAKE) --no-print-directory JITSI_SERVICE=$(patsubst buildx_%,%,$@) buildx

ifeq ($(TARGETPLATFORM), unsupported)
build:
	@echo "Unsupported native architecture"
	@exit 1
else
build:
	@echo "Building for $(TARGETPLATFORM)"
	docker build \
		$(BUILD_ARGS) --build-arg TARGETPLATFORM=$(TARGETPLATFORM) \
		--progress plain \
		--tag $(JITSI_REPO)/$(JITSI_SERVICE) \
		$(JITSI_SERVICE)
endif

$(addprefix build_,$(JITSI_SERVICES)):
	$(MAKE) --no-print-directory JITSI_SERVICE=$(patsubst build_%,%,$@) build

tag:
	docker tag $(JITSI_REPO)/$(JITSI_SERVICE) $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

push:
	docker push $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

%-all:
	@$(foreach SERVICE, $(JITSI_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) $(subst -all,;,$@))

dev:
	docker-compose -f ./docker-compose.yml -f ./docker-compose.dev.yml up -d --build $(SERVICE)

prod:
	docker-compose -f ./docker-compose.yml up -d --build $(SERVICE)

deploy:
	env $(cat .env | grep -e "^[A-Z]" | xargs) docker stack deploy -c jitsi_swarm.yml jitsi_swarm

clean:
	docker stack rm jitsi_swarm
	docker-compose stop
	yes | docker-compose rm
	yes | docker network prune

prepare:
	docker pull debian:bullseye-slim
	FORCE_REBUILD=1 $(MAKE)

.PHONY: all build tag push clean prepare release $(addprefix build_,$(JITSI_SERVICES)) $(JITSI_SERVICES)
