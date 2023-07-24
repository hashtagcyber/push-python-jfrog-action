#!/bin/sh -l

# Only take the tail of the repo name
if echo "$4" | grep -q "/"
then
    echo "Found /. Setting 2nd half as ARTIFACTORY_REPO"
    export ARTIFACTORY_REPO="${4#*/}"
else
    export ARTIFACTORY_REPO=$4
fi
export TWINE_USERNAME="$1"
export TWINE_PASSWORD="$2"
export TWINE_NON_INTERACTIVE=1
export TWINE_REPOSITORY_URL="$3/api/pypi/$4"
twine upload $5