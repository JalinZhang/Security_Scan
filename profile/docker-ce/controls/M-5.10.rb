control 'M-5.10' do
  title '5.10 Ensure memory usage for container is limited (Scored)'
  desc  "By default, all containers on a Docker host share the resources equally. By
  using the resource management capabilities of Docker host, such as memory limit, you
  can control the amount of memory that a container may consume.
  By default, the container can use all of the memory on the host. You can use the
  memory limit mechanism to prevent a denial of service arising from one container
  consuming all of the hosts resources such that other containers on the same host cannot perform
  their intended functions. Having no limit on memory can lead to issues where one container
  can easily make the whole system unstable and as a result unusable.
  "
  impact 0.5
  tag "ref": "1.
  https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/2.
  https://docs.docker.com/engine/reference/commandline/run/#options3.
  https://docs.docker.com/engine/admin/runmetrics/"
  tag "severity": 'medium'
  tag "cis_id": '5.10'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: Memory={{.HostConfig.Memory }}' If the above command returns 0, it means
  the memory limits are not in place. If the above command returns a non-zero
  value, it means memory limits are in place."
  tag "fix": "Run the container with only as much memory as required. Always
  run the container using the --memory argument. For example, you could run a
  container as below: docker run --interactive --tty --memory 256m centos
  /bin/bash In the above example, the container is started with a memory limit
  of 256 MB. Note: Please note that the output of the below command would return
  values in scientific notation if memory limits are in place. docker inspect
  --format='{{.Config.Memory}}' 7c5a2d4c7fe0 For example, if the memory limit is
  set to 256 MB for the above container instance, the output of the above
  command would be 2.68435456e+08 and NOT 256m. You should convert this value
  using a scientific calculator or programmatic methods."
  tag "Default Value": "By default, all containers on a Docker host share the
  resources equally. No memory limits are enforced."
  ref url: 'https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/'
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#run'
  ref url: 'https://docs.docker.com/v1.8/articles/runmetrics/'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig Memory}) { should_not eq 0 }
      end
    end
  end
end

