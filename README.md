The vagrant bought some cooking tools and set up shop on the corner, now he's cookin'.

A simple way to test chef cookbooks, roles, bootstraps, knife plugins, anything you like.


Prerequisites
-------------
bundler - you really should already have this installed
`gem install bundler`

virtualbox - it's what's for dinner
https://www.virtualbox.org/wiki/Downloads

Instructions
------------

1. `git clone git://github.com/agoddard/street-chef.git; cd street-chef`

2. `bundle install`

3. `librarian-chef install` (this will install the opscode community cookbooks which the chef-server bootstrap will need) 

4. `vagrant up`

5. Watch as your chef server is built and you get a few apps servers thrown in as tasty extras on the side.


Restarting: if you have an existing street-chef environment, you can reload it by simply calling 'vagrant up' from within the street-chef directory.

Note that sometimes the chef server node will sometimes fail on restart due to a race condition with the rabbit-mq server.  If you get stack traces with errors like "rabbitmqctl add_vhost /chef failed", this is likely the cause.  If this happens just do 'vagrant provision chef' to re-provision the chef node.

Usage
-----

All knife commands will work from the street-chef directory, except 'knife ssh' (still working on this) so `vagrant ssh` will have to do for now.
When you're done, just `vagrant destroy` to shut down and delete the VMs.
