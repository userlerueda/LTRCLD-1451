# Delete instances
openstack server list --all-projects
for instance in $(openstack server list --all-projects | grep tenant | awk '{ print $2 }'); do openstack server delete ${instance}; done
openstack server list --all-projects
# Delete images
openstack image list
for tenantimage in $(openstack image list | grep tenant | awk '{ print $2 }'); do openstack image delete ${tenantimage}; done
openstack image list
# Delete flavors
openstack flavor list --all
for flavor in $(openstack flavor list --all | grep tenant | awk '{ print $2 }'); do openstack flavor delete ${flavor}; done
openstack flavor list --all
# Delete Floatin IP lists
openstack floating ip list
for floating in $(openstack floating ip list | awk '{ print $2 }'); do openstack floating ip delete ${floating}; done
openstack floating ip list
# Delete Neworks
openstack network list
for network in $(openstack network list | grep tenant | awk '{ print $2 }'); do openstack network delete ${network}; done
openstack network list
# Delete Ports
openstack port list
openstack port list
# Delete Routers
openstack router list
openstack router list
# Delete Neworks
openstack network list
for network in $(openstack network list | grep tenant | awk '{ print $2 }'); do openstack network delete ${network}; done
openstack network list
