.PHONY: console

ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

# Heroku stack to use for the console. This can be override by setting STACK
# (e.g. STACK=heroku-22 make console).
STACK ?= "heroku-24"

# Change stack to image with tag (e.g. heroku/heroku:24-build)
IMAGE := "heroku/$(shell echo ${STACK} | sed 's/-/:/')-build"

console:
	@docker pull --quiet $(IMAGE)
	@echo

	@echo "Console Help"
	@echo
	@echo "Mounts this repository at /buildpack and drops you into the build image."
	@echo "From inside the container you can exercise the buildpack with:"
	@echo "    /cnb/lifecycle/detector -app /workspace -buildpack /buildpack -group /tmp/group -plan /tmp/plan"
	@echo "    /cnb/lifecycle/builder -app /workspace -layers /tmp/layers -group /tmp/group -plan /tmp/plan -platform /platform"
	@echo

	@docker run --rm -ti -v $(ROOT_DIR):/buildpack -e "STACK=$(STACK)" -w /buildpack $(IMAGE) \
		bash -c 'mkdir -p /workspace /layers /platform/env; exec bash'
