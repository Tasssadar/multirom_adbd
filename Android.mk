# Copyright 2005 The Android Open Source Project
#
# Android.mk for adb
#

LOCAL_PATH:= $(call my-dir)
# adbd device daemon
# =========================================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	adb.c \
	backup_service.c \
	fdevent.c \
	transport.c \
	transport_local.c \
	transport_usb.c \
	sockets.c \
	services.c \
	file_sync_service.c \
	jdwp_service.c \
	framebuffer_service.c \
	remount_service.c \
	usb_linux_client.c \
	log_service.c \
	utils.c

LOCAL_CFLAGS := -g -DADB_HOST=0 -Wall -Wno-unused-parameter -Wno-error=implicit-function-declaration
# adb can't be built without optimizations, so we enforce -O2 if no
# other optimization flag is set - but we don't override what the global
# flags are saying if something else is given (-Os or -O3 are useful)
ifeq ($(findstring -O, $(TARGET_GLOBAL_CFLAGS)),)
LOCAL_CFLAGS += -O2
endif
ifneq ($(findstring -O0, $(TARGET_GLOBAL_CFLAGS)),)
LOCAL_CFLAGS += -O2
endif
LOCAL_CFLAGS += -D_XOPEN_SOURCE -D_GNU_SOURCE

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
LOCAL_CFLAGS += -DALLOW_ADBD_ROOT=1
endif

ifeq ($(BOARD_ALWAYS_INSECURE),true)
	LOCAL_CFLAGS += -DBOARD_ALWAYS_INSECURE
endif

LOCAL_MODULE := mrom_adbd

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_UNSTRIPPED_PATH := $(TARGET_OUT_EXECUTABLES_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES := libcutils libc liblog
include $(BUILD_EXECUTABLE)
