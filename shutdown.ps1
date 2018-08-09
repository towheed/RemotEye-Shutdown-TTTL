# PowerShell and PowerCLI shutdown script for Toyota Trinidad and Tobago Ltd - Barataria
# Get the latest version from: https://github.com/towheed/RemotEye-Shutdown-TTTL/blob/master/shutdown.ps1

# Set tab=4

# (c) 2018 Towheed Mohammed <towheedm@yahoo.com>
#
#
# This package is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 dated June, 1991.
#
# This package is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA or visit https://www.gnu.org/licenses/gpl-2.0.html


# This script runs on the Primary Domain Controller. VMware's PowerCLI
# must be installed and properly configured prior to executing this script.
# The advantage is that it only uses one instance of Toshiba's shutdown
# software running on the PDC. The ESXi version is therefore not required.
#
# This allows the user easier maintenance of the automated shutdown from
# a single location and also allows fine-grained tuning of the shutdown
# procedures should the servers be updated, upgraded and/or replaced.
# This also has the advantage of not requiring the installation of vMA.


# The shutdown sequence is as follows:
# 1. Get list of all ESXi hosts
# 2. Get list of all currently running VM's on each ESXi host
# 3. Iterate thought the list of ESXi host and:
#       i.   Shutdown all VM's on current host
#       ii.  Wait for all VM's to shutdown
#       iii. Put host into 'Maintenance Mode'
#       iv.  Poweroff current ESXi host
# 4. Wait for all ESXi host to complete their poweroff sequence
# 5. Send remote shutdown command to the IBM Storewize SAN
# 6. Notify admin(s) that ESXi and SAN is down and PDC about to poweroff
# 7. Poweroff PDC

# A note on the above:
#
# We chose to simply shutdown each VM in Step 3-i, but this may also require
# that we disable 'Storage vMotion'.  Should this procedure that too long we
# can do the more technically correct thing and disable vMotion on all VM's and
# setting a DRS rule to have the VM's automatically poweroff with the host. This
# may nonetheless still require us to disable 'Storage vMotion'.
#
# Have a look at:
# https://www.virtuallyghetto.com/2016/07/how-to-easily-disable-vmotion-cross-vcenter-vmotion-for-a-particular-virtual-machine.html
# https://github.com/lamw/vghetto-scripts/blob/master/powershell/enable-disable-vsphere-api-method.ps1
# 
# CredentialStore:
# We choose to use the credential store to authenticate on the vCentre Server.
# This method has the advantage of not having to specify the passwords in
# plain text during authentication. To ensure this works properly, we must
# issue a 'New-VICredentialStoreItem' cmdlet manually to create the store if
# one does not already exist. Please take careful note of this, or else this
# script fails.

# Declare our vars centrally
$vc_server = "<ipv4 addr of the vcentre server>"
$vc_username = "<vcentre servr username>"
$vc_credentialstore_file = "<fully qualified filename to the credential store>"

# Get the credential store
$vc_credential = Get-VICredentialStoreItem -Host $vc_server -User $vc_username -File $vc_credentialstore_file

# Connect to the vCentre Server
$server = Connect-VIServer -Credential $vc_credential

# Get list of ESXi hosts
# TODO Do we need to get only 'connected' hosts?
$hosts=Get-VMHost -Server $server

# Get list of all virtual machines
$vms = Get-VM -Server $server

# Because vCentre Server is a VM, we remove it from the list
# TODO Remove $vc_server from list of VM's




# Iterate through list of ESXi hosts and get list of VM's
foreach ($host in $hosts) {
    $vms=<cmdlet>
    # TODO PowerCLI cmdlet to retrieve lists of VM on $host
    foreach ($vm in $vms) {
        # Poweroff $vm asynchronously
        # TODO PowerCLI cmdlet to poweroff $vm
    }
    # Check all VM's on $host are powered off
    # TODO PowerCLI cmdlet to check all VM's are powered off on $host
    
    # Put $host into 'Maintenance Mode'
    $task = Set-VMHost -VMHost $host -State "Maintenance" -RunAsync
    
    # Poweroff $host
    # TODO PowerCLI cmdlet to poweroff $host
}

# Send remote shutdown command to the IBM Storewize SAN
# TODO Command to poweroff SAN

# Notify admin(s) to current progress
# TODO PowerShell cmdlet to send email messages

# Shutdown the PDC
stop-computer
