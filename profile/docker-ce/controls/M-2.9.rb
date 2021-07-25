control 'M-2.9' do
  title '2.9 Ensure the default cgroup usage has been confirmed (Scored)'
  desc  "The --cgroup-parent option allows you to set the default cgroup parent to
  used for all the containers. If there is no specific use case, this setting should be left
  at its default. System administrators typically define cgroups under which containers are
  supposed to run. Even if cgroups are not explicitly defined by the system
  administrators, containers run under docker cgroup by default.
  It is possible to attach to a different cgroup other than the default. This usage should
  be monitored and confirmed. By attaching to a different cgroup than the default,
  it is possible to share resources unevenly and thus might starve
  the host for resources.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.9'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "ps -ef | grep dockerd Ensure that the --cgroup-parent
  parameter is either not set or is set as the appropriate nondefault cgroup."
  tag "fix": "The default setting is good enough and can be left as-is. If you
  want to specifically set a nondefault cgroup, pass --cgroup-parent parameter to
  the docker daemon when starting it. For Example, dockerd
  --cgroup-parent=/foobar"
  tag "Default Value": "By default, docker daemon uses /docker for fs cgroup
  driver and system.slice for systemd cgroup driver."
  ref 'Docker daemon configuration', url: 'https://docs.docker.com/engine/reference/commandline/daemon/'
  ref 'defaultcgroup-parent', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#defaultcgroup-parent'

  describe json('/etc/docker/daemon.json') do
    its(['cgroup-parent']) { should eq('docker') }
  end
end

