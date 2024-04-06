#!/bin/bash

# Copy a container from one repo (typically docker hub) to the local repo

# Should use skopeo instead (in the podman machine on macos)

from=$1
to=$2

echo From: \<$from\>
echo To: \<$to\>

podman pull $from
podman tag $from $to
podman push $to