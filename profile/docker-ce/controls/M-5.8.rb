control 'M-5.8' do
  title '5.8 Ensure only needed ports are open on the container (Scored)'
  desc  "The Dockerfile for a container image defines the ports to be opened by default
  on a container instance. The list of ports may or may not be relevant to the application
  you are running within the container. A container can be run just with the ports
  defined in the Dockerfile for its image or it can be arbitrarily passed run time parameters to
  open a list of ports. Additionally, overtime, the Dockerfile may undergo various changes and
  the list of exposed ports may or may not be relevant to the application you are running within
  the container. Opening unneeded ports sincrease the attack surface of the container
  and the containerized application. As a recommended practice, do not open unneeded ports.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/engine/userguide/networking/'
  tag "severity": 'medium'
  tag "cis_id": '5.8'
  tag "cis_control": ['9.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['CM-7(1)', '4']
  tag "check_text": "List all the running instances of containers and their port
  mapping by executing the below command: docker ps --quiet | xargs docker
  inspect --format '{{ .Id }}: Ports={{.NetworkSettings.Ports }}' Review the
  list and ensure that the ports mapped are the ones that are really needed
  for the container. "
  tag "fix": "Fix the Dockerfile of the container image to expose only needed
  ports by your containerized application. You can also completely ignore the
  list of ports defined in the Dockerfile by NOT using -P (UPPERCASE) or
  --publish-all flag when starting the container. Use the -p (lowercase) or
  --publish flag to explicitly define the ports that you need for a particular
  container instance. For example, docker run --interactive --tty --publish
  5000 --publish 5001 --publish 5002 centos /bin/bash"
  tag "Default Value": "By default, all the ports that are listed in the
  Dockerfile under EXPOSE instruction for an image are opened when a container
  is run with -P or --publish-all flag."
  ref 'binding', url: 'https://docs.docker.com/engine/userguide/networking/default_network/binding/'

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      container_info = docker.object(id)
      next if container_info['NetworkSettings']['Ports'].nil?

      container_info['NetworkSettings']['Ports'].each do |_, hosts|
        if !hosts.nil?
          hosts.each do |host|
            hostport = host['HostPort']
            describe "The docker container host port #{hostport} for container #{id}" do
              subject { hostport }
              it { should be_in attribute('allowed_ports') }
            end
          end
        else
          describe "There are no docker container port hosts defined for container #{id}, therefore this control is N/A" do
            skip "There are no docker container port hosts defined for container #{id}, therefore this control is N/A"
          end
        end
      end
    end
  else
    impact 0.0
    describe 'There are no docker containers running, therefore this control is N/A' do
      skip 'There are no docker containers running, therefore this control is N/A'
    end
  end
end

