#!/bin/sh

# Upload environment.
knife environment from file mblwhoi_environments/dev.json

# Set nodes to use dev environment.
knife exec -E 'nodes.transform("chef_environment:_default") { |n| n.chef_environment("dev") }'

# Upload roles.
for f in `ls -1 mblwhoi_chef/mblwhoi_roles/*.rb`; do knife role from file $f; done;

# Download and upload cookbooks.
cd mblwhoi_cookbooks; librarian-chef install; cd -; knife cookbook upload -a -o mblwhoi_cookbooks/cookbooks;

# Add vagrant-ohai to app1 and app2
knife cookbook upload vagrant-ohai -o site-cookbooks
for n in app1 app2; do knife node run_list add "${n}.streetchef.local" "recipe[vagrant-ohai]"; done

# Add backup manager recipe to app1.
knife node run_list add app1.streetchef.local "recipe[backup::manager]"

# Add backup client role to app2.
knife node run_list add app2.streetchef.local "recipe[backup::client]"

# Add mblwhoi server roles to app2.
for r in dla intranet library_legacy library; do knife node run_list add app2.streetchef.local "role[mblwhoi_${r}_webserver]"; done

# Run chef on the nodes.
vagrant provision app1
vagrant provision app2
