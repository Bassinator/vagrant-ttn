Vagrant.configure("2") do |config|
  #config.vm.network "private_network", ip: "192.168.0.2"

  config.vm.define "client" do |client|
    client.vm.box = "centos/7"
    client.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    client.vm.provider 'virtualbox' do |vb|
      vb.memory = 2048
      vb.gui = true
      vb.cpus = 2
      vb.customize ['modifyvm', :id, '--vram', '64']
      vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    end

    client.vm.provision "ansible_local" do |a|
      a.playbook = "prerequisites.yml"
    end

    client.vm.provision "ansible_local" do |a|
      a.playbook = "ide.yml"
    end
  end


  config.vm.define "pio" do |pio|
    pio.vm.provider 'docker' do |d|
      d.image = "bassualdo/centosvagrant"
      d.has_ssh = true
    end

    pio.vm.provision "ansible_local" do |a|
      a.verbose = "v"
      a.playbook = "pio-core.yml"
    end
  end

  config.vm.define "ttn" do |ttn|
    ttn.vm.provider 'docker' do |d|
      d.image = "bassualdo/centosvagrant"
      d.has_ssh = true
    end

    ttn.vm.provision "ansible_local" do |a|
      a.verbose = "vvv"
      a.playbook = "ttn.yml"
    end
  end

end
