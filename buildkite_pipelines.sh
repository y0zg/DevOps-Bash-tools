#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-03-11 18:02:32 +0000 (Wed, 11 Mar 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

# shellcheck disable=SC2034
usage_description="
Lists BuildKite pipelines in slug format (re-usable in API), one per line to make it easy to iterate on them

eg. trigger a build of each pipeline:

./buildkite_pipelines.sh | while read pipeline; do ./buildkite_trigger.sh \"\$pipeline\"; done
"

[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

# remember to set this eg. BUILDKITE_ORGANIZATION="hari-sekhon"
BUILDKITE_ORGANIZATION="${BUILDKITE_ORGANIZATION:-${BUILDKITE_USER:-}}"

check_env_defined BUILDKITE_TOKEN
check_env_defined BUILDKITE_ORGANIZATION

help_usage "$@"

"$srcdir/buildkite_api.sh" "/organizations/$BUILDKITE_ORGANIZATION/pipelines" | jq -r '.[].slug'
