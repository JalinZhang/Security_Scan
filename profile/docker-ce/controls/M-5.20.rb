control 'M-5.20' do
  title "5.20 Ensure the host's UTS namespace is not shared (Scored)"
  desc  "The UTS namespaces provide isolation of two system identifiers: the hostname
  and the NIS domain name. It is used for setting the hostname and the domain that is
  visible to running processes in that namespace. Processes running within containers are not
  typically requiredto know the hostname and domain name. Hence, the namespace should not be shared
  with the host. Sharing the UTS namespace with the host provides full permissions to the
  container to change the hostname of the host. This is insecure and should not be allowed.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/run/#uts-settings-uts2.
  http://man7.org/linux/man-pages/man7/namespaces.7.html"
  tag "severity": 'medium'
  tag "cis_id": '5.20'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: UTSMode={{ .HostConfig.UTSMode }}' If the above command returns host, it
  means the host UTS namespace is shared with the container and this
  recommendation is non-compliant. If the above command returns nothing, then
  the host's UTS namespace is not shared. This recommendation is
  then compliant."
  tag "fix": "Do not start a container with --uts=host argument. For example,
  do not start a container as below: docker run --rm --interactive --tty
  --uts=host rhel7.2"
  tag "Default Value": "By default, all containers have the UTS namespace
  enabled and host UTS namespace is not shared with any container."
  ref url: 'https://docs.docker.com/engine/reference/run/'
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
        its(%w{HostConfig UTSMode}) { should_not eq 'host' }
      end
    end
  end
end

