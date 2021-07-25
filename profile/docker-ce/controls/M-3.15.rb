control 'M-3.15' do
  title '3.15 Ensure that Docker socket file ownership is set to root:docker(Scored)'
  desc  "Verify that the Docker socket file is owned by root and group-owned by
  docker. The docker daemon runs as root. The default Unix socket hence must be owned by
  root. If any other user or process owns this socket, then it might be possible for that
  non-privileged user or process to interact with the docker daemon. Also, such a non-privileged
  user or process might interact with containers. This is neither a secure nor desired
  behavior. Additionally, the Docker installer creates a Unix group called docker. You
  can add users to this group, and then those users would be able to read and write to the default
  Docker Unix socket. The membership to the docker group is tightly controlled by the
  system administrator. If any other group owns this socket, then it might be
  possible for members of that group to interact with the Docker daemon. Also, such a group might not
  be as tightly controlled as the docker group. This is neither secure nor desired behavior.
  Hence, the default Docker Unix socket file must be owned by root and group-owned by
  docker to maintain the integrity of the socket file.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/dockerd/#daemonsocket-option2.
  https://docs.docker.com/engine/reference/commandline/dockerd/#bind-dockerto-another-hostport-or-a-unix-socket"
  tag "severity": 'medium'
  tag "cis_id": '3.15'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the Docker socket file
  is owned by root and group-owned by docker: stat -c %U:%G
  /var/run/docker.sock | grep -v root:docker The above command should not return
  anything."
  tag "fix": "chown root:docker /var/run/docker.sock This would set the
  ownership to root and group-ownership to docker for the default Docker socket file."
  tag "Default Value": "By default, the ownership and group-ownership for
  the Docker socket file is correctly set to root:docker."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#daemon-socket-option'
  ref url: 'https://docs.docker.com/engine/quickstart/'

  describe file('/var/run/docker.sock') do
    it { should exist }
    it { should be_socket }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'docker' }
  end
end

