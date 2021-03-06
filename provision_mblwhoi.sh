#!/bin/sh

# Upload environment.
knife environment from file mblwhoi_environments/dev.json

# Set nodes to use dev environment.
knife exec -E 'nodes.transform("chef_environment:_default") { |n| n.chef_environment("dev") }'

# Upload roles.
for f in `ls -1 chef-repo/roles/mblwhoi*.rb`; do knife role from file $f; done;

# Upload databags.
for d in `ls -1 chef-repo/data_bags`; do 
    if [ -d chef-repo/data_bags/$d ]; then 
        knife data bag create $d; 
        for f in `ls chef-repo/data_bags/$d/*.json`; do 
            knife data bag from file $d $f; 
        done 
    fi 
done

# Download and upload cookbooks.
cd mblwhoi_cookbooks; librarian-chef install; cd -; knife cookbook upload -a -o mblwhoi_cookbooks/cookbooks;

# Add vagrant-ohai to app1 and app2
knife cookbook upload vagrant-ohai -o site-cookbooks
for n in app1 app2; do knife node run_list add "${n}.streetchef.local" "recipe[vagrant-ohai]"; done

# Add backup manager recipe to app1.
knife node run_list add app1.streetchef.local "recipe[backup::manager]"

# Add mblwhoi server roles to app2.
for r in dla intranet library_legacy library; do knife node run_list add app2.streetchef.local "role[mblwhoi_${r}_webserver]"; done

# Run chef on the nodes, three times to get the backup job registration correct.
for i in {1..3}; do for a in app1 app2; do vagrant provision $a; done; done;
