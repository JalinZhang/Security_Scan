control 'M-5.11' do
  title '5.11 Ensure CPU priority is set appropriately on the container (Scored)'
  desc  "By default, all containers on a Docker host share the resources equally. By
  using the resource management capabilities of Docker host, such as CPU shares, you
  can control the host CPU resources that a container may consume.
  By default, CPU time is divided between containers equally. If it is
  desired, to control the CPU time amongst the container instances, you can use the CPU sharing feature.
  CPU sharing allows you to prioritize one container over the other and forbids the lower
  priority container to claim CPU resources more often. This ensures that the high priority
  containers are served better.
  "
  impact 0.5
  tag "ref": "1.
  https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/\n2.
  https://docs.docker.com/engine/reference/commandline/run/#options\n3.
  https://docs.docker.com/engine/admin/runmetrics/\n"
  tag "severity": 'medium'
  tag "cis_id": '5.11'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: CpuShares={{ .HostConfig.CpuShares }}' If the above command returns 0 or
  1024, it means the CPU shares are not in place. If the above command returns a
  non-zero value other than 1024, it means CPU shares are in place."
  tag "fix": "Manage the CPU shares between your containers. To do so start the
  container using the -cpu-shares argument. For example, you could run a
  container as below: docker run --interactive --tty --cpu-shares 512 centos
  /bin/bash In the above example, the container is started with CPU shares of
  50% of what the other containers use. So, if the other container has CPU
  shares of 80%, this container will have CPU shares of 40%. Note: Every new
  container will have 1024 shares of CPU by default. However, this value
  is shown as 0 if you run the command mentioned in the audit
  section. Alternatively, 1. Navigate to /sys/fs/cgroup/cpu/system.slice/
  directory. 2. Check your container instance ID using docker ps. 3. Now,
  inside the above directory (in step 1), you would have a directory by
  name docker-<Instance ID>.scope. For example,
  docker4acae729e8659c6be696ee35b2237cc1fe4edd2672e9186434c5116e1a6fbed6.scope. Navigate
  to this directory. 4. You will find a file named cpu.shares. Execute cat
  cpu.shares. This will always give you the CPU share value based on the system.
  So, even if there is no CPU shares configured using -c or --cpu-shares
  argument in the docker run command, this file will have a value of 1024. If
  we set one containers CPU shares to 512 it will receive half of the CPU time
  compared to the other container. So, take 1024 as 100% and then do quick math
  to derive the number that you should set for respective CPU shares. For
  example, use 512 if you want to set 50% and 256 if you want to set 25%."
  tag "Default Value": "By default, all containers on a Docker host share the
  resources equally. No CPU shares are enforced."
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
        its(%w{HostConfig CpuShares}) { should_not eq 0 }
        its(%w{HostConfig CpuShares}) { should_not eq 1024 }
      end
    end
  end
end

