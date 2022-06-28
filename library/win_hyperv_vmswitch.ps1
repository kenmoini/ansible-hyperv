#!powershell
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

# WANT_JSON
# POWERSHELL_COMMON

#Requires -Module Ansible.ModuleUtils.Legacy
Set-StrictMode -Version 2

#########################################################################################################################################
# Functions
#########################################################################################################################################

Function VirtualSwitch-Create {
  #Check If the VirtualSwitch already exists
  $CheckVirtualSwitch = Get-VMSwitch -name $name -ErrorAction SilentlyContinue
  
  if (!$CheckVirtualSwitch) {
    $cmd = "New-VMSwitch -Name $name"
    
    if ($switchType) {
      $cmd += " -SwitchType $switchType"
    }
    
    if ($adapterName) {
      $cmd += " -NetAdapterName '$adapterName'"
    }
    
    if ($allowManagementOS) {
      if ($allowManagementOS -eq "enabled") {
        $b = $true
        $cmd += ' -AllowManagementOS $b '
      }
      if ($allowManagementOS -eq "disabled") {
        $b = $false
        $cmd += ' -AllowManagementOS $b '
      }
    }

    $result.cmd_used = $cmd
    $result.changed = $true
    
    if (!$check_mode) {
      $results = invoke-expression -Command "$cmd"
    }
  } else {
    $result.changed = $false
  }
}

Function VirtualSwitch-Delete {
  $CheckVirtualSwitch = Get-VMSwitch -name $name -ErrorAction SilentlyContinue
  
  if ($CheckVirtualSwitch) {
    $cmd="Remove-VMSwitch -Name $name -Force"
    $result.cmd_used = $cmd
    $result.changed = $true

    if (!$check_mode) {
      $results = invoke-expression $cmd
    }
  } else {
    $result.changed = $false
  }
}

#########################################################################################################################################
# Parameter Setup
#########################################################################################################################################

$params = Parse-Args $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$result = @{
  changed = $false
  cmd_used = ""
}

$debug_level = Get-AnsibleParam -obj $params -name "_ansible_verbosity" -type "int"
$debug = $debug_level -gt 2

$name = Get-AnsibleParam $params "name" -type "str" -FailIfEmpty $true -emptyattributefailmessage "missing required argument: name"
$state = Get-AnsibleParam $params "state" -type "str" -FailIfEmpty $true -emptyattributefailmessage "missing required argument: state"
$switchType = Get-AnsibleParam $params "switchType" -type "str" -aliases "type" -Default $null
$adapterName = Get-AnsibleParam $params "adapterName" -type "str" -aliases "adapter" -Default $null
$allowManagementOS = Get-AnsibleParam $params "allowManagementOS" -type "string" -Default $null

#########################################################################################################################################
# State Action Switches
#########################################################################################################################################

Try {
  switch ($state) {
    "present" {VirtualSwitch-Create}
    "absent" {VirtualSwitch-Delete}
  }
  Exit-Json $result;
} Catch {
  Fail-Json $result $_.Exception.Message
}
