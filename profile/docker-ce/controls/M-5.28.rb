control 'M-5.28' do
  title '5.28 Ensure PIDs cgroup limit is used (Scored)'
  desc  "Use the --pids-limit flag at container runtime.
  Attackers could launch a fork bomb with a single command inside the
  container. This fork bomb can crash the entire system and requires a restart of the host to make
  the system functional again. The PIDs cgroup --pids-limit will prevent this kind of
  attack by restricting the number of forks that can happen inside a container at a given time.
  "
  impact 0.5
  tag "ref": "1. https://github.com/docker/docker/pull/186972.
  https://docs.docker.com/engine/reference/commandline/run/#options"
  tag "severity": 'medium'
  tag "cis_id": '5.28'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run the below command and ensure that PidsLimit is not set to 0
  or -1. A PidsLimit of 0 or -1 means that any number of processes can be forked
  inside the container concurrently. docker ps --quiet --all | xargs docker
  inspect --format '{{ .Id }}: PidsLimit={{ .HostConfig.PidsLimit }}'"
  tag "fix": "Use the --pids-limit flag while launching the container with an
  appropriate value. For example, docker run -it --pids-limit 100
  <Image_ID> In the above example, the number of processes allowed to run at any
  given time is set to 100. After a limit of 100 concurrently running processes
  is reached, docker would restrict any new process creation."
  tag "Default Value": "The Default value for the --pids-limit is 0 which means
  there is no restriction on the number of forks. Also, note that the PIDs cgroup
  limit works only for the kernel versions 4.3+."
  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its('HostConfig.PidsLimit') { should_not cmp 0 }
        its('HostConfig.PidsLimit') { should_not cmp(-1) }
      end
    end
  end
end

