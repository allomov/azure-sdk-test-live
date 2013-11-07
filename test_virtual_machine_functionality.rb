require 'config'


VirtualMachineManager = Azure::VirtualMachineManagement::VirtualMachineManagementService

 # Accepted key/value pairs are:
 # * +:vm_name+        - String.  Name of virtual machine.
 # * +:vm_user+        - String.  User name for the virtual machine instance.
 # * +:password+       - String.  A description for the hosted service.
 # * +:image+          - String.  Name of the disk image to use to create the virtual machine.
 # * +:location+       - String.  The location where the virtual machine will be created.
 # Accepted key/value pairs are:
 # * +:storage_account_name+     - String. Name of storage account.
 # * +:cloud_service_name+       - String. Name of cloud service.
 # * +:deployment_name+          - String. A name for the deployment.
 # * +:tcp_endpoints+            - String. Specifies the external port and internal port separated by a colon.
 # * +:ssh_private_key_file+     - String. Path of private key file.
 # * +:ssh_certificate_file+     - String. Path of certificate file.
 # * +:ssh_port+                 - Integer. Specifies the SSH port number.
 # * +:vm_size+                  - String. Specifies the size of the virtual machine instance.  
 # * +:winrm_transport+          - Array. Specifies WINRM transport protocol.

params = {
      vm_name: 'instance1',
      vm_user: 'root',
      image: "5112500ae3b842c8b9c604889f8753c3__OpenLogic-CentOS-63APR20130415",
      password: 'root',
      location: 'West US'
}

VirtualMachineManager.new.create_virtual_machine(params)

VirtualMachine.list_virtual_machines.each { |vm| puts "Virtual Machine: #{vm.vm_name}" }


Azure::VirtualMachineManagement::VirtualMachineManagementService.new.create_virtual_machine(vm_name: 'instance1', vm_user: 'root', image: "5112500ae3b842c8b9c604889f8753c3__OpenLogic-CentOS-63APR20130415", password: 'root', location: 'West US')
