control 'M-5.15' do
  title "5.15 Ensure the host's process namespace is not shared (Scored)"
  desc  "Process ID (PID) namespaces isolate the process ID number space, meaning
  that processes in different PID namespaces can have the same PID. This is a process level
  isolation between containers and the host.
  PID namespace provides separation of processes. The PID Namespace removes
  the view of the system processes, and allows process ids to be reused including PID 1.
  If the host's PID namespace is shared with the container, it would basically allow processes
  within the container to see all of the processes on the host system. This breaks the
  benefit of process level isolation between the host and the containers. Someone having access
  to the container can eventually know all the processes running on the host system
  and can even kill the host system processes from within the container. This can be
  catastrophic. Hence, do not share the host's process namespace with the containers.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/run/#pid-settings-pid2.
  http://man7.org/linux/man-pages/man7/pid_namespaces.7.html"
  tag "severity": 'medium'
  tag "cis_id": '5.15'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: PidMode={{ .HostConfig.PidMode }}' If the above command returns host, it
  means the host PID namespace is shared with the container else this
  recommendation is compliant."
  tag "fix": "Do not start a container with --pid=host argument. For example,
  do not start a container as below: docker run --interactive --tty --pid=host
  centos /bin/bash"
  tag "Default Value": "By default, all containers have the PID namespace
  enabled and the host's process namespace is not shared with the containers."
  ref url: 'https://docs.docker.com/engine/reference/run/#pid-settings'
  ref url: 'http://man7.org/linux/man-pages/man7/pid_namespaces.7.html'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig PidMode}) { should_not eq 'host' }
      end
    end
  end
end

