LOCAL_LD_PATH   ?= `pwd`/dynlib
LIBSASS_VERSION ?= 3.4.5
BUILD           ?= shared

dep: $(LOCAL_LD_PATH)/lib

$(LOCAL_LD_PATH)/lib: libsass-$(LIBSASS_VERSION)/lib
	BUILD="$(BUILD)" PREFIX="$(LOCAL_LD_PATH)" make -C "libsass-$(LIBSASS_VERSION)" install

install-libsass: libsass-$(LIBSASS_VERSION)/lib
	BUILD="$(BUILD)" make -C "libsass-$(LIBSASS_VERSION)" install
	ldconfig

libsass-$(LIBSASS_VERSION)/lib: libsass-$(LIBSASS_VERSION)
	BUILD="$(BUILD)" make -C "libsass-$(LIBSASS_VERSION)" -j5

libsass-$(LIBSASS_VERSION):
	curl -L "https://github.com/sass/libsass/archive/$(LIBSASS_VERSION).tar.gz" | tar -xz

.PHONY: spec
spec: dep
	LIBRARY_PATH="$(LOCAL_LD_PATH)/lib" LD_LIBRARY_PATH="$(LOCAL_LD_PATH)/lib" crystal spec

clean: clean-dynlib
	rm -rf libsass-$(LIBSASS_VERSION)

clean-dynlib:
	rm -rf $(LOCAL_LD_PATH)

clean-all: clean-dynlib
	rm -rf libsass-*
