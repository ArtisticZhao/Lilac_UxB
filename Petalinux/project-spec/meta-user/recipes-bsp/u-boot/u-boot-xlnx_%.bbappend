FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://platform-top.h \
            file://user_2021-11-10-14-51-00.cfg \
            "
SRC_URI += "file://0001-JEDEC-id-uboot.patch \
            file://0002-513-qspi-flash.patch \
            file://0003-fix-printf-message.patch"
