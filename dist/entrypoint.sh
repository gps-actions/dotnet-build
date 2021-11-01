#!/bin/bash

export BUILD_ROOT_PATH=$1
export BUILD_CONFIGURATION=$2
export BUILD_PLATFORM=$3
export BUILD_RESTORE=$4

chmod +x /build.ps1

pwsh /build.ps1

echo "Executed powershell."
