# vagrant

```bash
# Initate Vagrant
mkdir vag-vm; cd vag-vm
vagrant init

# Add a box to vagrant repo
vagrant box add hashicorp/precise32

# Add a box  Vagrant file
config.vm.box = "hashicorp/precise32"

# Add provision script to vagrant file
config.vm.provision :shell, path: "provision.sh"

# Start vm 
vagrant up

# login and share
vagrant login && vagrant share

vagrant share --ssh --ssh-once
vagrant connect --ssh <NAME>

# Connect to started instance
vagrant ssh

# Shutdown vm
vagrant halt

# Hibernate vm
vagrant suspend

# Set vm to initial state by cleaning all data
vagrant destroy

# Restart vm with new provision script
vagran reload --provision
```
