control 'M-2.8' do
  title '2.8 Enable user namespace support (Scored)'
  desc  "Enable user namespace support in Docker daemon to utilize container user to
 host user remapping. This recommendation is beneficial where the containers you are
 using do not have an explicit container user defined in the container image. If container images
 that you are using have a pre-defined non-root user, this recommendation may be skipped
 since this feature is still in its infancy and might give you unpredictable issues and complexities.
 The Linux kernel user namespace support in Docker daemon provides additional security
 for the Docker host system. It allows a container to have a unique range of
 user and group IDs which are outside the traditional user and group range utilized by the
 host system. For example, the root user will have expected administrative privilege
 inside the container but can effectively be mapped to an unprivileged UID on the host system.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.8'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "ps -p $(docker inspect --format='{{ .State.Pid }}' <CONTAINER
  ID>) -o pid,user The above command would find the PID of the container and
  then would list the host user associated with the container process. If the
  container process is running as root, then this recommendation is non-compliant.
  Alternatively, you can run docker info to ensure that the
  user is listed under Security Options: docker info --format '{{ .SecurityOptions }}'"
  tag "fix": "Please consult Docker documentation for various ways in which
  this can be configured depending upon your requirements. Your steps might also
  vary based on platform - For example, on Red Hat, sub-UIDs and sub-GIDs
  mapping creation does not work automatically. You might have to create your
  own mapping. However, the high-level steps are as below: Step 1: Ensure that
  the files /etc/subuid and /etc/subgid exist. touch /etc/subuid
  /etc/subgid Step 2: Start the docker daemon with --userns-remap flag dockerd
  --userns-remap=default"
  tag "Default Value": 'By default, user namespace is not remapped.'
  ref 'User namespeces', url: 'http://man7.org/linux/man-pages/man7/user_namespaces.7.html'
  ref 'daemon-usernamespace-options', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-usernamespace-options'
  ref 'Docker daemon configuration', url: 'https://docs.docker.com/engine/reference/commandline/daemon/'
  ref 'Routing out root: user namespaces in docker', url: 'http://events.linuxfoundation.org/sites/events/files/slides/User%20Namespaces%20-%20ContainerCon%202015%20-%2016-9-final_0.pdf'
  ref 'Docker images vanish when using user namespaces ', url: 'https://github.com/docker/docker/issues/21050'

  describe json('/etc/docker/daemon.json') do
    its(['userns-remap']) { should eq('default') }
  end
  describe file('/etc/subuid') do
    it { should exist }
    it { should be_file }
  end
  describe file('/etc/subgid') do
    it { should exist }
    it { should be_file }
  end
end

