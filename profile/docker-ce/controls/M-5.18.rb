control 'M-5.18' do
  title '5.18 Ensure the default ulimit is overwritten at runtime, only if needed (Not Scored)'
  desc  "The default ulimit is set at the Docker daemon level. However, you may
  override the default ulimit setting, if needed, during container runtime.
  The ulimit provides control over the resources available to the shell and to
  processes started by it. Setting system resource limits judiciously saves you from many
  disasters such as a fork bomb. Sometimes, even friendly users and legitimate processes can
  overuse system resources and in-turn can make the system unusable.
  The default ulimit set at the Docker daemon level should be honored. If the
  default ulimit settings are not appropriate for a particular container instance, you may
  override them as an exception. But, do not make this a practice. If most of the container
  instances are overriding the default ulimit settings, consider changing the default ulimit
  settings to something that is appropriate for your needs.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/run/#set-ulimits-incontainer-ulimit2.
  http://www.oreilly.com/webops-perf/free/files/docker-security.pdf"
  tag "severity": 'medium'
  tag "cis_id": '5.18'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}:Ulimits={{ .HostConfig.Ulimits }}' The above command should return
  Ulimits=<no value> for each container instance until and unless there is an
  exception and a need to override the default ulimit settings."
  tag "fix": "Only override the default ulimit settings if needed. For
  example, to override default ulimit settings start a container as
  below: docker run --ulimit nofile=1024:1024 --interactive --tty centos
  /bin/bash"
  tag "Default Value": "Container instances inherit the default ulimit settings
  set at the Docker daemon level."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#setting-ulimits-in-a-container'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig Ulimits}) { should eq nil }
      end
    end
  end
end

