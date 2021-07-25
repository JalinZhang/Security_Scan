control 'M-5.24' do
  title '5.24 Ensure cgroup usage is confirmed (Scored)'
  desc  "It is possible to attach to a particular cgroup on a container run.
  Confirming cgroup usage would ensure that containers are running under defined cgroups.
  System administrators typically define cgroups under which containers are
  supposed to run. Even if cgroups are not explicitly defined by the system
  administrators, containers run under the docker cgroup by default.
  At run-time, it is possible to attach to a different cgroup other than the
  one that was expected to be used. This usage should be monitored and confirmed. By
  attaching to a different cgroup than the one that is expected, excess permissions and
  resources might be granted to the container and thus, can prove to be unsafe.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/run/#specify-custom-cgroups2.
  https://access.redhat.com/documentation/enUS/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/ch01.html"
  tag "severity": 'medium'
  tag "cis_id": '5.24'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: CgroupParent={{ .HostConfig.CgroupParent }}' The above command would
  return the cgroup under which the containers are running. If it is blank, it
  means containers are running under the default docker cgroup. In that case,
  this recommendation is compliant. If the containers are found to be running
  under a cgroup other than the one that was expected, this recommendation is
  non-compliant."
  tag "fix": 'Do not use the --cgroup-parent option in the docker run command unless needed.'
  tag "Default Value": 'By default, containers run under docker cgroup.'
  ref url: 'https://docs.docker.com/engine/reference/run/#specifying-custom-cgroups'
  ref url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/ch01.html'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig CgroupParent}) { should be_empty }
      end
    end
  end
end

