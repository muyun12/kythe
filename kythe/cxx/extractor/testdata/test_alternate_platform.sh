#!/bin/bash -e
# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
TEST_NAME="test_alternate_platform"
. ./kythe/cxx/extractor/testdata/test_common.sh
KYTHE_OUTPUT_DIRECTORY="${OUT_DIR}" \
"${EXTRACTOR}" --with_executable "arm-none-linux-gnueabi-g++" \
    -mcpu=cortex-a15 \
    -I./kythe/cxx/extractor \
    ./kythe/cxx/extractor/testdata/arm.cc
[[ $(ls -1 "${OUT_DIR}"/*.kindex | wc -l) -eq 1 ]]
INDEX_PATH=$(ls -1 "${OUT_DIR}"/*.kindex)
"${KINDEX_TOOL}" -canonicalize_hashes -suppress_details -explode "${INDEX_PATH}"
sed "s|TEST_CWD|${PWD}/|" "${BASE_DIR}/arm.UNIT" | diff - "${INDEX_PATH}_UNIT"
