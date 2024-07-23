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

data "google_dns_managed_zone" "dns_zone" {
  project = var.project_id
  name    = var.zone
}


resource "google_dns_record_set" "name_servers" {
  project = var.project_id
  name    = "${var.subdomain}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type    = "NS"
  ttl     = var.ttl

  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = var.name_servers
}

