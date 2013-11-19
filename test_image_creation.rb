require './config'
require 'debugger'

VirtualMachineManager = Azure::VirtualMachineManagement::VirtualMachineManagementService

image_file = './tmp/image.jpg'
image_blob_name = "image-blob"
image_container_name = "image-container"


# Create an azure storage blob service object
azure_blob_service = Azure::BlobService.new

# azure_blob_service.delete_container(image_container_name)
# puts "Container #{image_container_name} is deleted."


# Create a container
# TODO: add method to check if it container exists 
# container = azure_blob_service.create_container(image_container_name)

# Upload a Blob
# TODO: upload a file, not content
# content = File.open(image_file, 'rb') { |file| file.read }
content_file = File.open(image_file, 'r') do |file|
  azure_blob_service.create_block_blob(image_container_name, image_blob_name, file)  
end







# # List Containers
# puts "Containers List:"
# azure_blob_service.list_containers().each { |c| puts c.name }

# # List Blobs
# puts "Blobs List:"
# azure_blob_service.list_blobs(container.name).each { |b| puts b.name }

# # Delete a Blob
# azure_blob_service.delete_blob(container.name, image_blob_name)
# puts "Blob #{image_blob_name} is deleted."

# # Delete a Container
# azure_blob_service.delete_container(image_container_name)
# puts "Container #{image_container_name} is deleted."
