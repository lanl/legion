#!/bin/bash

set -e

root_dir="$(dirname "${BASH_SOURCE[0]}")"
cd "$root_dir"

source env.sh # defines PERF_ACCESS_TOKEN

export CI_RUNNER_DESCRIPTION="titan.ccs.ornl.gov"

../common/nightly.sh

