control 'M-5.30' do
  title "5.30 Ensure the host's user namespaces is not shared (Scored)"
  desc  "Do not share the host's user namespaces with the containers.
  User namespaces ensure that a root process inside the container will be
  mapped to a nonroot process outside the container. Sharing the user namespaces
  of the host with the container thus does not isolate users on the host with users on the
  containers.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/security/userns-remap/2.
  https://docs.docker.com/engine/reference/commandline/run/#options3.
  https://github.com/docker/docker/pull/126484.
  https://events.linuxfoundation.org/sites/events/files/slides/User%20Namespaces%20-%20ContainerCon%202015%20-%2016-9-final_0.pdf"
  tag "severity": 'medium'
  tag "cis_id": '5.30'
  tag "cis_control": ['12', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SC-7', '4']
  tag "check_text": "Run the below command and ensure that it does not return any
  value for UsernsMode. If it returns a value of host, it means the host user
  namespace is shared with the containers. docker ps --quiet --all | xargs
  docker inspect --format '{{ .Id }}: UsernsMode={{ .HostConfig.UsernsMode }}'"
  tag "fix": "Do not share user namespaces between host and containers. For
  example, do not run a container as below: docker run --rm -it --userns=host
  ubuntu bash"
  tag "Default Value": "By default, the host user namespace is shared with the
  containers until user namespace support is enabled."

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its('HostConfig.UsernsMode') { should eq '' }
      end
    end
  end
end

