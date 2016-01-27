#Set hostname from parameter
	require 'getoptlong'

	opts = GetoptLong.new(
		[ '--name', GetoptLong::OPTIONAL_ARGUMENT ]
	)

	name='Work'

	opts.each do |opt, arg|
		case opt
			when '--name'
		name=arg
		end
	end


Vagrant.configure("2") do |config|
	
	#Set up instance
	config.vm.define "#{name}" do |test|
  		
		test.vm.box = "chef/centos-6.5"
		
		test.vm.network "public_network", bridge: "Realtek PCIe GBE Family Controller"
		
		test.vm.provider "virtualbox" do |vb|
    			
			vb.name = "#{name}"
			
			vb.memory = "512"
  		
		end
	
	config.vm.provision "shell" do |s|
		s.inline = "sudo hostname $1 && sudo sed -i \"s/^HOSTNAME.*/HOSTNAME=$1/\" $2"
		s.args   = ["#{name}", "/etc/sysconfig/network"]
	end
	
	config.vm.provision :chef_solo do |chef|
		chef.add_recipe "workplace"
		chef.log_level = :debug
	end
	
	end

end	