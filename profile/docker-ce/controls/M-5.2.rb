control 'M-5.2' do
  title '5.2 Ensure SELinux security options are set, if applicable (Scored)'
  desc  "SELinux is an effective and easy-to-use Linux application security system.
  It is available on quite a few Linux distributions by default such as Red Hat and Fedora.
  SELinux provides a Mandatory Access Control (MAC) system that greatly augments the
  default Discretionary Access Control (DAC) model. You can thus add an extra
  layer of safety by enabling SELinux on your Linux host, if applicable.
  "
  impact 0.5
  tag "ref":
  '1.2.3.4. https://docs.docker.com/engine/security/security/#other-kernel-security-features https://docs.docker.com/engine/reference/run/#security-configuration http://docs.fedoraproject.org/en-US/Fedora/13/html/Security-Enhanced_Linux/ https://access.redhat.com/documentation/enus/red_hat_enterprise_linux_atomic_host/7/html/container_security_guide/docker_selinux_security_policy'
  tag "severity": 'medium'
  tag "cis_id": '5.2'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: SecurityOpt={{ .HostConfig.SecurityOpt }}' The above command should
  return all the security options currently configured for the containers."
  tag "fix": "If SELinux is applicable for your Linux OS, use it. You may have
  to follow below set of steps: Set the SELinux State. Set the
  SELinux Policy. Create or import a SELinux policy template for Docker
  containers. Start Docker in daemon mode with SELinux enabled. For
  example, docker daemon --selinux-enabled. Start your Docker container using
  the security options. For example, docker run --interactive --tty
  --security-opt label=level:TopSecret centos /bin/bash"
  tag "Default Value": "By default, no SELinux security options are applied on
  containers."
  ref 'Bug: Wrong SELinux label for devmapper device', url: 'https://github.com/docker/docker/issues/22826'
  ref 'Bug: selinux break docker user namespace', url: 'https://bugzilla.redhat.com/show_bug.cgi?id=1312665'
  ref url: 'https://docs.docker.com/engine/security/security/'
  ref url: 'https://docs.docker.com/engine/reference/run/#security-configuration'
  ref url: 'https://docs.fedoraproject.org/en-US/Fedora/13/html/Security-Enhanced_Linux/'

  only_if { %w{centos redhat}.include? os[:name] }
  describe json('/etc/docker/daemon.json') do
    its(['selinux-enabled']) { should eq(true) }
  end

  docker.containers.running?.ids.each do |id|
    describe docker.object(id) do
      its(%w{HostConfig SecurityOpt}) { should_not eq nil }
      its(%w{HostConfig SecurityOpt}) { should include attribute('selinux_profile') }
    end
  end
end

