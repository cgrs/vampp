Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname ="vampp"
  config.vm.network "private_network", ip: "192.168.100.100"
  config.vm.synced_folder "www/", "/var/www/html"
  config.vm.provision "shell", path: "setup.sh"
end
