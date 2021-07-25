control 'M-5.1' do
  title '5.1 Ensure AppArmor Profile is Enabled (Scored)'
  desc  "AppArmor is an effective and easy-to-use Linux application security system.
  It is available on quite a few Linux distributions by default such as Debian and Ubuntu.
  AppArmor protects the Linux OS and applications from various threats by
  enforcing a security policy which is also known as AppArmor profile. You can create
  your own AppArmor profile for containers or use the Docker's default AppArmor
  profile. This would enforce security policies on the containers as defined in the profile.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/security/apparmor/2.
  https://docs.docker.com/engine/reference/run/#security-configuration3.
  https://docs.docker.com/engine/security/security/#other-kernel-security-features"
  tag "severity": 'medium'
  tag "cis_id": '5.1'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: AppArmorProfile={{ .AppArmorProfile }}' The above command should return a
  valid AppArmor Profile for each container instance."
  tag "fix": "If AppArmor is applicable for your Linux OS, use it. You may have
  to follow below set of steps: Verify if AppArmor is
  installed. If not, install it. Create or import a AppArmor profile for Docker
  containers. Put this profile in enforcing mode. Start your Docker container
  using the customized AppArmor profile. For example, docker run --interactive
  --tty --security-opt=\"apparmor:PROFILENAME\" centos/bin/bash Alternatively,
  you can keep the docker's default apparmor profile."
  tag "Default Value": "By default, docker-default AppArmor profile is applied
  for running containers and this profile can be found at
  /etc/apparmor.d/docker."
  ref 'https://docs.docker.com/engine/security/security/'
  ref 'https://docs.docker.com/engine/reference/run/#security-configuration'
  ref 'http://wiki.apparmor.net/index.php/Main_Page'

  only_if { %w{ubuntu debian}.include? os[:name] }

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(['AppArmorProfile']) { should include attribute('app_armor_profile') }
        its(['AppArmorProfile']) { should_not eq nil }
      end
    end
  end
end

