#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_X11_OPTION='1'
SHED_PKG_LOCAL_EGL_OPTION='1'
for SHED_PKG_LOCAL_OPTION in "${!SHED_PKG_LOCAL_OPTIONS[@]}"; do
    case "$SHED_PKG_LOCAL_OPTION" in
        x11)
            SHED_PKG_LOCAL_X11_OPTION='0'
            ;;
        egl)
            SHED_PKG_LOCAL_EGL_OPTION='0'
            ;;
    esac
done
# Build and Install
mkdir -pv build &&
cd build &&
cmake -DODROID=1                          \
      -DNOEGL=$SHED_PKG_LOCAL_EGL_OPTION  \
      -DNOX11=$SHED_PKG_LOCAL_X11_OPTION  \
      -DDEFAULT_ES=2                      \
      -DCMAKE_INSTALL_PREFIX=/usr         \
      .. &&
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
# Rearrange, install symlinks and pkgconfig
install -v -dm755 "${SHED_FAKE_ROOT}/usr/lib/pkgconfig" &&
install -v -m644 "${SHED_PKG_CONTRIB_DIR}/gl.pc" "${SHED_FAKE_ROOT}/usr/lib/pkgconfig" &&
mv "${SHED_FAKE_ROOT}/usr/lib/gl4es/libGL.so.1" "${SHED_FAKE_ROOT}/usr/lib/" &&
rmdir "${SHED_FAKE_ROOT}/usr/lib/gl4es" &&
ln -sv libGL.so.1 "${SHED_FAKE_ROOT}/usr/lib/libGL.so"
