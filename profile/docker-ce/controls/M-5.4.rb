control 'M-5.4' do
  title '5.4 Ensure privileged containers are not used (Scored)'
  desc  "Using the --privileged flag gives all Linux Kernel Capabilities to the
  container thus overwriting the --cap-add and --cap-drop flags. Ensure that it is not used.
  The --privileged flag gives all capabilities to the container, and it also
  lifts all OF the limitations enforced by the device cgroup controller. In other words, the
  container can then do almost everything that the host can do. This flag exists to allow
  special use-cases, like running Docker within Docker.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linuxcapabilities"
  tag "severity": 'medium'
  tag "cis_id": '5.4'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: Privileged={{ .HostConfig.Privileged }}' The above command should return
  Privileged=false for each container instance."
  tag "fix": "Do not run container with the --privileged flag. For example, do
  not start a container as below: docker run --interactive --tty --privileged
  centos /bin/bash"
  tag "Default Value": 'False.'
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig Privileged}) { should eq false }
        its(%w{HostConfig Privileged}) { should_not eq true }
      end
    end
  end
end

