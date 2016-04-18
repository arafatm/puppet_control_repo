# Quickstart - NOT VALID FOR CODEMANAGER
* install PE all-in-one master with installer
* Create SSH key for Puppet to use for r10k deploy and interaction with your Git repository.
* mkdir /etc/puppetlabs/puppetserver/ssh and place key in this directory.
* In 'PE Master' node group in the console, under the puppet_enterprise::profile::master class, specify the
  parameters, r10k_remote and r10k_private_key with the Git repo you're using and the key location you just
  created in previous step.
* rm -rf /etc/puppetlabs/code/environments/production, git clone this repo as 'production'
* Bring up a node to be the gitlab server, install PE agent from master, classify with profile::gitlab, run puppet
* log into gitlab with root/5iveL!fe, create r10k_api_user, create user for you, create 'puppet' group and 'control-repo' project
* make users above 'Master' members of the puppet/control-repo project
* add you ssh key to your user from dev machine, git clone this repo, set remote to be gitlab, push
* log in as r10k_api_user, find the api token, classify master with profile::puppetmaster in console and set api token param
* run puppet on master. 

To-do: open ports like 4433, 8123, 8081 on MoM only for API access.


