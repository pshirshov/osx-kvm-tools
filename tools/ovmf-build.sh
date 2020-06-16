#!/bin/bash -xe

target=`pwd`/ovmf

pushd .
cd /tmp
rm -rf edk2

git clone https://github.com/tianocore/edk2.git

cd edk2
git submodule update --init

make -C BaseTools
source edksetup.sh

cat <<EOT >> Conf/target.txt
ACTIVE_PLATFORM       = OvmfPkg/OvmfPkgX64.dsc
TARGET_ARCH           = X64
TOOL_CHAIN_TAG        = GCC5
TARGET                = RELEASE
EOT

build

popd

mkdir -p $target
cp edk2/Build/OvmfX64/RELEASE_GCC5/FV/OVMF_*.fd $target/
