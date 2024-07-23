#!/bin/bash
# Copyright 2023 Google LLC
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


# read 3 parameters, CLUSTER_NAME, PROJECT_ID, CLUSTER_LOCATION
read -p "Enter cluster name : " CLUSTER_NAME
read -p "Enter project id: " PROJECT_ID
read -p "Enter cluster location: " CLUSTER_LOCATION

# gcloud command to get gke cluster credentials
gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --project=${PROJECT_ID} \
    --zone=${CLUSTER_LOCATION}