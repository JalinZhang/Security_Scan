control 'M-5.31' do
  title '5.31 Ensure the Docker socket is not mounted inside any containers (Scored)'
  desc  "The docker socket docker.sock should not be mounted inside a container.
  If the docker socket is mounted inside a container it would allow processes
  running within the container to execute docker commands which effectively allows for full
  control of the host.
  "
  impact 0.5
  tag "ref": "1.
  https://raesene.github.io/blog/2016/03/06/The-Dangers-Of-Docker.sock/2.
  https://forums.docker.com/t/docker-in-docker-vs-mounting-var-run-dockersock/9450/23.
  https://github.com/docker/docker/issues/21109"
  tag "severity": 'medium'
  tag "cis_id": '5.31'
  tag "cis_control": ['9', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SC-7', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: Volumes={{ .Mounts }}' | grep docker.sock The above command would return
  any instances where docker.sock had been mapped to a container as a volume."
  tag "fix": 'Ensure that no containers mount docker.sock as a volume.'
  tag "Default Value": "By default, docker.sock is not mounted inside
  containers."
  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      if !docker.object(id).Mounts.empty?
        docker.object(id).Mounts.each do |mount|
          describe mount do
            its('Source') { should_not include 'docker.sock' }
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

