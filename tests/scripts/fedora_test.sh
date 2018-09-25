#!/bin/bash
# Copyright 2018 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

images=(
"fedora:latest"
)

git_root=$(git rev-parse --show-toplevel)
readonly git_root

for image in "${images[@]}"; do
  docker pull "${image}"
  docker run --rm -it --entrypoint=/bin/bash --volume="${git_root}:/src:ro" "${image}" -c """
set -exuo pipefail

# Install bazel
dnf install -qy dnf-plugins-core
dnf copr enable -y vbatts/bazel
dnf install -qy python gcc bazel

# Run tests
cd /src
tests/scripts/run_tests.sh -t llvm_toolchain_6_0_0
"""
done
