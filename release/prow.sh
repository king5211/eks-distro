#!/usr/bin/env bash
# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
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

if [ "$AWS_ROLE_ARN" == "" ]; then
    echo "Empty AWS_ROLE_ARN"
    exit 1
fi
BASE_DIRECTORY=$(git rev-parse --show-toplevel)
cd ${BASE_DIRECTORY}
RELEASE_ENVIRONMENT=${RELEASE_ENVIRONMENT:-development}

export RELEASE=$(cat ${BASE_DIRECTORY}/release/${RELEASE_BRANCH}/${RELEASE_ENVIRONMENT}/RELEASE)
export KUBE_BASE_TAG=$(cat ${BASE_DIRECTORY}/projects/kubernetes/release/${RELEASE_BRANCH}/GIT_TAG)-eks-${RELEASE_BRANCH}-${RELEASE}
export PRESUBMIT_KUBE_BASE_TAG=$(cat ${BASE_DIRECTORY}/projects/kubernetes/release/${RELEASE_BRANCH}/GIT_TAG)-eks-${RELEASE_BRANCH}-${RELEASE}
export BASE_REPO=${BASE_REPO:-${IMAGE_REPO}}
export BASE_IMAGE=${BASE_IMAGE:-public.ecr.aws/eks-distro-build-tooling/eks-distro-base:$(cat ${BASE_DIRECTORY}/EKS_DISTRO_BASE_TAG_FILE)}

cp -r /$HOME/.docker ${BASE_DIRECTORY}
export DOCKER_CONFIG=${BASE_DIRECTORY}/.docker
${BASE_DIRECTORY}/development/ecr/ecr-command.sh install-ecr-public
${BASE_DIRECTORY}/development/ecr/ecr-command.sh login-ecr-public
make release ${*}
