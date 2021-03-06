#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail
source ./scripts/env.sh

log "🕸  Adding VM to the mesh..."
export GCE_IP=$(gcloud --format="value(networkInterfaces[0].networkIP)" compute instances describe ${GCE_INSTANCE_NAME} --zone ${GCE_INSTANCE_ZONE})
log "GCE IP is ${GCE_IP}"

kubectl config use-context ${CTX_1}
../../common/istio-1.5.2/bin/istioctl experimental add-to-mesh external-service productcatalogservice ${GCE_IP} grpc:3550 -n default

kubectl config use-context ${CTX_2}
../../common/istio-1.5.2/bin/istioctl experimental add-to-mesh external-service productcatalogservice ${GCE_IP} grpc:3550 -n default


log "✅ done."