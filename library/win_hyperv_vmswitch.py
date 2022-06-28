#!/usr/bin/python
# -*- coding: utf-8 -*-

# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub. actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_hyperv_vmswitch
version_added: "2.5"
short_description: Adds, deletes and performs configuration of Hyper-V Virtual Switch.
description:
    - Adds, deletes and performs configuration of Hyper-V Virtual Switch.
options:
  name:
    description:
      - Name of Virtual Switch
    required: true
  state:
    description:
      - State of Virtual Switch
    required: false
    choices:
      - present
      - absent
    default: present
  switchType:
    description:
      - Type of Virtual Switch
    required: false
    choices:
      - External
      - Internal
      - Private
    default: External
  adapterName:
    description:
      - Name of the physical adapter to be used for the Virtual Switch
    required: false
    default: null
  allowManagementOS:
    description:
      - Specifies whether the Virtual Switch can be managed by the Hyper-V Management Service. enabled|disabled
    required: false
    default: false
'''

EXAMPLES = '''
  # Create Virtual Switch bridged from Ethernet Adapter 1
  win_hyperv_vmswitch:
    name: VMNetwork
    state: present
    switchType: External
    adapterName: Ethernet Adapter 1
    allowManagementOS: true

  # Delete a Virtual Switch
  win_hyperv_vmswitch:
    name: VMNetwork
    state: absent

  # Create an Internally routed Virtual Switch
  win_hyperv_vmswitch:
    name: natty
    state: present
    switchType: Internal

  # Create a Private Virtual Switch
  win_hyperv_vmswitch:
    name: NoNet
    state: present
    switchType: Private
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
