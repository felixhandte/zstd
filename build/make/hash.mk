UNAME ?= $(shell uname)

ifndef BUILD_DIR
ifeq ($(UNAME), Darwin)
  ifeq ($(shell md5 < /dev/null > /dev/null; echo $$?), 0)
    HASH ?= md5
  endif
else ifeq ($(UNAME), FreeBSD)
  HASH ?= gmd5sum
else ifeq ($(UNAME), NetBSD)
  HASH ?= md5 -n
else ifeq ($(UNAME), OpenBSD)
  HASH ?= md5
endif
HASH ?= md5sum
HAVE_HASH :=$(shell echo 1 | $(HASH) > /dev/null && echo 1 || echo 0)

HASH_DIR = conf_$(shell echo $(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(ZSTD_FILES) | $(HASH) | cut -f 1 -d " ")
ifeq ($(HAVE_HASH),0)
  $(info warning : could not find HASH ($(HASH)), needed to differentiate builds using different flags)
  BUILD_DIR := obj/generic_noconf
endif
endif # BUILD_DIR
