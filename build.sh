#!/bin/bash
# Build and Install
mkdir -pv build
cd build
cmake -DODROID=1                       \
      -DNOX11=1                        \
      -DDEFAULT_ES=2                   \
      -DCMAKE_INSTALL_PREFIX=/usr      \
      .. &&                            \
make -j $SHED_NUM_JOBS &&              \
make DESTDIR="$SHED_FAKE_ROOT" install
