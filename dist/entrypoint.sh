#!/bin/bash

export BUILD_ROOT_PATH=$1
export BUILD_CONFIGURATION=$2
export BUILD_PLATFORM=$3
export BUILD_RESTORE=$4

chmod +x /build.ps1

pwsh /build.ps1

status=$(cat /etc/hostname)

echo "Powershell exited with $status"

echo "::set-output name=build-result::$status"

if (($? != 0)); then
  printf '%s\n' "Powershell failed" >&2  # write error message to stderr
  exit $?                                  # or exit $test_result
fi