control 'M-5.5' do
  title '5.5 Ensure sensitive host system directories are not mounted on containers (Scored)'
  desc  "Sensitive host system directories such as below should not be allowed to be
  mounted as container volumes especially in read-write mode.
  /
  /boot
  /dev
  /etc
  /lib
  /proc
  /sys
  /usr
  If sensitive directories are mounted in read-write mode, it would be
  possible to make changes to files within those sensitive directories. The changes might
  bring down security implications or unwarranted changes that could put the Docker host in
  a compromised state.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/tutorials/dockervolumes/\n"
  tag "severity": 'medium'
  tag "cis_id": '5.5'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: Volumes={{ .Mounts }}' The above commands would return the list of
  current mapped directories and whether they are mounted in read-write mode for
  each container instance."
  tag "fix": "Do not mount host sensitive directories on containers especially
  in read-write mode."
  tag "Default Value": "Docker defaults to a read-write volume but you can also
  mount a directory read-only. By default, no sensitive host directories are
  mounted on containers."
  ref url: 'https://docs.docker.com/engine/userguide/containers/dockervolumes/'

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      info = docker.object(id)
      if !info['Mounts'].empty?
        info['Mounts'].each do |mounts|
          describe mounts['Source'] do
            it { should_not eq '/' }
            it { should_not match(%r{\/boot}) }
            it { should_not match(%r{\/dev}) }
            it { should_not match(%r{\/etc}) }
            it { should_not match(%r{\/lib}) }
            it { should_not match(%r{\/proc}) }
            it { should_not match(%r{\/sys}) }
            it { should_not match(%r{\/usr}) }
          end
        end
      else
        impact 0.0
        describe 'There are no docker container mounts, therefore this control is N/A' do
          skip 'There are no docker container mounts, therefore this control is N/A'
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

