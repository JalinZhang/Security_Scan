control 'M-5.16' do
  title "5.16 Ensure the host's IPC namespace is not shared (Scored)"
  desc  "The IPC (POSIX/SysV IPC) namespace provides separation of named shared memory
  segments, semaphores and message queues. IPC namespace on the host thus should not be
  shared with the containers and should remain isolated.
  The IPC namespace provides separation of the IPC between the host and containers.
  If the host's IPC namespace is shared with the container, it would basically allow
  processes within the container to see all of the IPC on the host system. This breaks the benefit
  of IPC level isolation between the host and the containers. Someone having access to the
  container can eventually manipulate the host IPC. This can be catastrophic. Hence, do not
  share the host's IPC namespace with the containers.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/run/#ipc-settings-ipc2.
  http://man7.org/linux/man-pages/man7/namespaces.7.html"
  tag "severity": 'medium'
  tag "cis_id": '5.16'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}:IpcMode={{ .HostConfig.IpcMode }}' If the above command returns host, it
  means the host IPC namespace is shared with the container. If the above
  command returns nothing, then the host's IPC namespace is not shared. This
  recommendation is then compliant."
  tag "fix": "Do not start a container with --ipc=host argument. For example,
  do not start a container as below: docker run --interactive --tty --ipc=host
  centos /bin/bash"
  tag "Default Value": "By default, all containers have the IPC namespace
  enabled and host IPC namespace is not shared with any container."
  ref url: 'https://docs.docker.com/engine/reference/run/#ipc-settings'
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
        its(%w{HostConfig IpcMode}) { should_not eq 'host' }
      end
    end
  end
end

