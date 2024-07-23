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


variable "project_id" {
  description = "Project ID"
  type        = string
  default     = "luissala-dns"
}

variable "zone" {
  description = "DNS Zone Name"
  type        = string
  default     = "luissala-dns-zone"
}

variable "subdomain" {
  description = "subdomain name, eg. if the root domain is 'example.com', and we want a subdomain 'foo.example.com', then subdomain is 'foo'"
  type        = string
}

variable "name_servers" {
  description = "List of name servers"
  type        = list(string)
}

variable "ttl" {
  description = "The Time-To-Live in seconds. Defaults to 60 seconds."
  type        = number
  default     = 60
}