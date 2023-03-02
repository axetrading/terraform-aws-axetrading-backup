#!/bin/bash

set -eo pipefail

docker run --rm -i -v "$PWD:$PWD" -w "$PWD" hashicorp/terraform:1.3.9 fmt --recursive