control 'M-5.3' do
  title '5.3 Ensure Linux Kernel Capabilities are restricted within containers (Scored)'
  desc  "By default, Docker starts containers with a restricted set of Linux Kernel
  Capabilities. This means that any process may be granted the required capabilities instead of
  root access. When using Linux Kernel Capabilities, the processes do not have to run as root
  for almost all of the specific areas where root privileges are usually needed.
  Docker supports the addition and removal of capabilities, allowing the use
  of a non-default profile. This may make Docker more secure through capability removal, or
  less secure through the addition of capabilities. It is thus recommended to remove all
  capabilities except those explicitly required for your container process.
  For example, capabilities such as below are usually not needed for
  container process:
  NET_ADMIN
  SYS_ADMIN
  SYS_MODULE
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/security/security/#linux-kernel-capabilities2.
  http://man7.org/linux/man-pages/man7/capabilities.7.html3.
  http://www.oreilly.com/webops-perf/free/files/docker-security.pdf"
  tag "severity": 'medium'
  tag "cis_id": '5.3'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: CapAdd={{.HostConfig.CapAdd }} CapDrop={{ .HostConfig.CapDrop }}' Verify
  that the added and dropped Linux Kernel Capabilities are in line with the
  ones needed for the container process for each container instance."
  tag "fix": "Execute the below command to add needed capabilities: $> docker
  run --cap-add={\"Capability 1\",\"Capability 2\"} For example, docker run
  --interactive --tty --cap-add={\"NET_ADMIN\",\"SYS_ADMIN\"} centos:latest
  /bin/bash Execute the below command to drop unneeded capabilities: $> docker
  run --cap-drop={\"Capability 1\",\"Capability 2\"} For example, docker run
  --interactive --tty --cap-drop={\"SETUID\",\"SETGID\"}
  centos:latest /bin/bash Alternatively, You may choose to drop all
  capabilities and add only add the needed ones: $> docker run --cap-drop=all
  --cap-add={\"Capability 1\",\"Capability 2\"} For example, docker run
  --interactive --tty --cap-drop=all --capadd={\"NET_ADMIN\",\"SYS_ADMIN\"}
  centos:latest /bin/bash"
  tag "Default Value": "By default, the below capabilities are available for
  containers: AUDIT_WRITE, CHOWN, DAC_OVERRIDE, FOWNER FSETID, KILL, MKNOD, NET_BIND_SERVICE,
  NET_RAW, SETFCAP, SETGID, SETPCAP, SETUID, SYS_CHROOT"
  ref url: 'https://docs.docker.com/engine/security/security/'
  ref url: 'http://man7.org/linux/man-pages/man7/capabilities.7.html'
  ref url: 'https://github.com/docker/docker/blob/master/oci/defaults_linux.go#L64-L79'
  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig CapDrop}) { should include(/all/) }
        its(%w{HostConfig CapDrop}) { should_not eq nil }
        its(%w{HostConfig CapAdd}) { should eq attribute('container_capadd') }
      end
    end
  end
end

