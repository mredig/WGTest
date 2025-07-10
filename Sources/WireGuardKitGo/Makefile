# SPDX-License-Identifier: MIT
#
# Copyright (C) 2018-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

ARCHS ?= x86_64 arm64
MACOS_PLATFORM_NAME = macosx
MACOS_ARCHS = x86_64 arm64
IOS_PLATFORM_NAME = iphoneos
IOS_ARCHS = arm64
IOS_SIM_PLATFORM_NAME = iphonesimulator
IOS_SIM_ARCHS = arm64 x86_64
# PLATFORM_NAME ?= $(MACOS_PLATFORM_NAME)
# SDKROOT ?= $(call get_sdkroot,$(PLATFORM_NAME))
MACOS_CONFIGURATION_BUILD_DIR ?= $(CURDIR)/out-macos
IOS_CONFIGURATION_BUILD_DIR ?= $(CURDIR)/out-ios
IOS_SIM_CONFIGURATION_BUILD_DIR ?= $(CURDIR)/out-ios-sim
CONFIGURATION_BUILD_DIR ?= $(CURDIR)/out
CONFIGURATION_TEMP_DIR ?= $(CURDIR)/.tmp

define get_sdkroot
$(shell xcrun --sdk $(1) --show-sdk-path)
endef

MACOS_SDKROOT = $(call get_sdkroot,$(MACOS_PLATFORM_NAME))
IOS_SDKROOT = $(call get_sdkroot,$(IOS_PLATFORM_NAME))
IOS_SIM_SDKROOT = $(call get_sdkroot,$(IOS_SIM_PLATFORM_NAME))

export PATH := $(PATH):/usr/local/bin:/opt/homebrew/bin
export CC ?= clang
LIPO ?= lipo
MACOS_DESTDIR ?= $(MACOS_CONFIGURATION_BUILD_DIR)
IOS_DESTDIR ?= $(IOS_CONFIGURATION_BUILD_DIR)
IOS_SIM_DESTDIR ?= $(IOS_SIM_CONFIGURATION_BUILD_DIR)
DESTDIR ?= $(CONFIGURATION_BUILD_DIR)
BUILDDIR ?= $(CONFIGURATION_TEMP_DIR)/wireguard-go-bridge

MACOS_CFLAGS_PREFIX := $(if $(DEPLOYMENT_TARGET_CLANG_FLAG_NAME),-$(DEPLOYMENT_TARGET_CLANG_FLAG_NAME)=$($(DEPLOYMENT_TARGET_CLANG_ENV_NAME)),) -isysroot $(MACOS_SDKROOT) -arch
IOS_CFLAGS_PREFIX := $(if $(DEPLOYMENT_TARGET_CLANG_FLAG_NAME),-$(DEPLOYMENT_TARGET_CLANG_FLAG_NAME)=$($(DEPLOYMENT_TARGET_CLANG_ENV_NAME)),) -isysroot $(IOS_SDKROOT) -arch
IOS_SIM_CFLAGS_PREFIX := $(if $(DEPLOYMENT_TARGET_CLANG_FLAG_NAME),-$(DEPLOYMENT_TARGET_CLANG_FLAG_NAME)=$($(DEPLOYMENT_TARGET_CLANG_ENV_NAME)),) -isysroot $(IOS_SIM_SDKROOT) -arch
# CFLAGS_PREFIX := $(if $(DEPLOYMENT_TARGET_CLANG_FLAG_NAME),-$(DEPLOYMENT_TARGET_CLANG_FLAG_NAME)=$($(DEPLOYMENT_TARGET_CLANG_ENV_NAME)),) -isysroot $(SDKROOT) -arch
GOARCH_arm64 := arm64
GOARCH_x86_64 := amd64
GOOS_macosx := darwin
GOOS_iphoneos := ios

macos-build: $(MACOS_DESTDIR)/libwg-go.a
ios-build: $(IOS_DESTDIR)/libwg-go.a $(IOS_SIM_DESTDIR)/libwg-go.a
macos-version-header: $(MACOS_DESTDIR)/wireguard-go-version.h
ios-version-header: $(IOS_DESTDIR)/wireguard-go-version.h $(IOS_SIM_DESTDIR)/wireguard-go-version.h 
# build: $(DESTDIR)/libwg-go.a
build: $(IOS_DESTDIR)/libwg-go.a $(MACOS_DESTDIR)/libwg-go.a $(IOS_SIM_DESTDIR)/libwg-go.a
# build: $(BUILDDIR)/libwg-go-arm64.a $(BUILDDIR)/libwg-go-x86_64.a
version-header: $(DESTDIR)/wireguard-go-version.h

REAL_GOROOT := $(shell go env GOROOT 2>/dev/null)
export GOROOT := $(BUILDDIR)/goroot
$(GOROOT)/.prepared:
	[ -n "$(REAL_GOROOT)" ]
	mkdir -p "$(GOROOT)"
	rsync -a --delete --exclude=pkg/obj/go-build "$(REAL_GOROOT)/" "$(GOROOT)/"
	cat goruntime-*.diff | patch -p1 -f -N -r- -d "$(GOROOT)"
	touch "$@"


# define libwg-go-a
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: export CGO_ENABLED := 1
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: export CGO_CFLAGS := $(2) $(1)
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: export CGO_LDFLAGS := $(2) $(1)
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: export GOOS := $(GOOS_$(3))
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: export GOARCH := $(GOARCH_$(1))
# $(BUILDDIR)/libwg-go-$(1)-$(3).a: $(GOROOT)/.prepared go.mod
# 	echo "-------building $(1)-$(3)-----------"
# 	go build -ldflags=-w -trimpath -v -o "$(BUILDDIR)/libwg-go-$(1)-$(3).a" -buildmode c-archive
# 	rm -f "$(BUILDDIR)/libwg-go-$(1)-$(3).h"

# $(info debug: libwg-go-$(1)-$(3).a)
# endef

# ARCH-$(1) CFLAGS_PREFIX-$(2)  PLATFORM_NAME-$(3)
define libwg-go-a
$(BUILDDIR)/libwg-go-$(3)-$(1).a: export CGO_ENABLED := 1
$(BUILDDIR)/libwg-go-$(3)-$(1).a: export CGO_CFLAGS := $(2) $(1)
$(BUILDDIR)/libwg-go-$(3)-$(1).a: export CGO_LDFLAGS := $(2) $(1)
$(BUILDDIR)/libwg-go-$(3)-$(1).a: export GOOS := $(GOOS_$(3))
$(BUILDDIR)/libwg-go-$(3)-$(1).a: export GOARCH := $(GOARCH_$(1))
$(BUILDDIR)/libwg-go-$(3)-$(1).a: $(GOROOT)/.prepared go.mod
	echo "🟨🟨🟨🟨🟨 building $(3) $(1) 🟨🟨🟨🟨🟨"
	env | grep CGO_ENABLED=
	env | grep CGO_CFLAGS=
	env | grep CGO_LDFLAGS=
	env | grep GOOS=
	env | grep GOARCH=
	$(info 'target 🎯: $(3) $(1)')
	go build -ldflags=-w -trimpath -v -o "$(BUILDDIR)/libwg-go-$(3)-$(1).a" -buildmode c-archive
	rm -f "$(BUILDDIR)/libwg-go-$(1).h"
endef
# $(foreach ARCH,$(ARCHS),$(eval $(call libwg-go-a,$(ARCH),$(CFLAGS_PREFIX),$(PLATFORM_NAME))))

$(foreach ARCH,$(MACOS_ARCHS),$(eval $(call libwg-go-a,$(ARCH),$(MACOS_CFLAGS_PREFIX),$(MACOS_PLATFORM_NAME))))
$(foreach ARCH,$(IOS_ARCHS),$(eval $(call libwg-go-a,$(ARCH),$(IOS_CFLAGS_PREFIX),$(IOS_PLATFORM_NAME))))
$(foreach ARCH,$(IOS_SIM_ARCHS),$(eval $(call libwg-go-a,$(ARCH),$(IOS_SIM_CFLAGS_PREFIX),$(IOS_SIM_PLATFORM_NAME))))

# define versionheader-sed
# $(1)/wireguard-go-version.h: go.mod $(GOROOT)/.prepared
# 	 sed -E -n 's/.*golang\.zx2c4\.com\/wireguard +v[0-9.]+-[0-9]+-([0-9a-f]{8})[0-9a-f]{4}.*/#define WIREGUARD_GO_VERSION "\1"/p' "$<" > "$@"
# endef

# $(call versionheader-sed, $(MACOS_DESTDIR))
# $(call versionheader-sed, $(IOS_DESTDIR))

$(MACOS_DESTDIR)/wireguard-go-version.h: go.mod $(GOROOT)/.prepared
	 sed -E -n 's/.*golang\.zx2c4\.com\/wireguard +v[0-9.]+-[0-9]+-([0-9a-f]{8})[0-9a-f]{4}.*/#define WIREGUARD_GO_VERSION "\1"/p' "$<" > "$@"
$(IOS_DESTDIR)/wireguard-go-version.h: go.mod $(GOROOT)/.prepared
	 sed -E -n 's/.*golang\.zx2c4\.com\/wireguard +v[0-9.]+-[0-9]+-([0-9a-f]{8})[0-9a-f]{4}.*/#define WIREGUARD_GO_VERSION "\1"/p' "$<" > "$@"
$(IOS_SIM_DESTDIR)/wireguard-go-version.h: go.mod $(GOROOT)/.prepared
	 sed -E -n 's/.*golang\.zx2c4\.com\/wireguard +v[0-9.]+-[0-9]+-([0-9a-f]{8})[0-9a-f]{4}.*/#define WIREGUARD_GO_VERSION "\1"/p' "$<" > "$@"


$(MACOS_DESTDIR)/libwg-go.a: $(foreach ARCH,$(MACOS_ARCHS),$(BUILDDIR)/libwg-go-$(MACOS_PLATFORM_NAME)-$(ARCH).a)
	@mkdir -vp "$(MACOS_DESTDIR)"
	$(LIPO) -create -output "$@" $^

$(IOS_DESTDIR)/libwg-go.a: $(foreach ARCH,$(IOS_ARCHS),$(BUILDDIR)/libwg-go-$(IOS_PLATFORM_NAME)-$(ARCH).a)
	@mkdir -vp "$(IOS_DESTDIR)"
	$(LIPO) -create -output "$@" $^

$(IOS_SIM_DESTDIR)/libwg-go.a: $(foreach ARCH,$(IOS_SIM_ARCHS),$(BUILDDIR)/libwg-go-$(IOS_SIM_PLATFORM_NAME)-$(ARCH).a)
	@mkdir -vp "$(IOS_SIM_DESTDIR)"
	$(LIPO) -create -output "$@" $^

# define lipo-platform-binaries
# $(1)/libwg-go.a: $(2)
# 	@mkdir -vp "$(1)"
# 	$(LIPO) -create -output "$@" $^
# endef

# $(call lipo-platform-binaries, $(MACOS_DESTDIR),$(MACOS_LIBWG_TARGETS))
# $(call lipo-platform-binaries, $(IOS_DESTDIR),$(IOS_LIBWG_TARGETS))


define clean-output
rm -rf "$(1)" "$(2)/libwg-go.a" "$(2)/wireguard-go-version.h"
endef

clean:
	$(call clean-output,$(BUILDDIR),$(MACOS_DESTDIR))
	$(call clean-output,$(BUILDDIR),$(IOS_DESTDIR))
	$(call clean-output,$(BUILDDIR),$(IOS_SIM_DESTDIR))
	rm -rf "$(BUILDDIR)" "$(DESTDIR)/libwg-go.a" "$(DESTDIR)/wireguard-go-version.h"

install-macos: macos-build
install-ios: ios-build
install: build

.PHONY: clean macos-build ios-build version-header install-macos install-ios debug build install
