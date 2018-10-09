#!/bin/bash
# This script is deprecated. Use bin/create-hooks instead.

mobius_shell_dir="$(cd $(dirname $0) && pwd)/.."
exec ${mobius_shell_dir}/bin/create-hooks
