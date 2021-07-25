control 'M-5.6' do
  title '5.6 Ensure ssh is not run within containers (Scored)'
  desc  "SSH server should not be running within the container. You should SSH into
  the Docker host, and use nsenter tool to enter a container from a remote host.
  Running SSH within the container increases the complexity of security
  management by making it
  Difficult to manage access policies and security compliance for SSH server
  Difficult to manage keys and passwords across various containers
  Difficult to manage security upgrades for SSH server
  It is possible to have shell access to a container without using SSH, and
  needlessly increasing the complexity of security management should be avoided.
  "
  impact 0.5
  tag "ref": "1.
  http://blog.docker.com/2014/06/why-you-dont-need-to-run-sshd-in-docker/"
  tag "severity": 'medium'
  tag "cis_id": '5.6'
  tag "cis_control": ['9.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['CM-7(1)', '4']
  tag "check_text": "Step 1: List all the running instances of containers by
  executing the below command: docker ps --quiet Step 2: For each container
  instance, execute the below command: docker exec $INSTANCE_ID ps -el Ensure
  that there is no process for SSH server."
  tag "fix": "Uninstall SSH server from the container and use nsenteror or any
  other commands such as docker exec or docker attach to interact with the
  container instance. docker exec --interactive --tty $INSTANCE_ID
  sh OR docker attach $INSTANCE_ID"
  tag "Default Value": "By default, SSH server is not running inside the
  container. Only one process per container is allowed."
  ref url: 'https://blog.docker.com/2014/06/why-you-dont-need-to-run-sshd-in-docker/'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      execute_command = 'docker exec ' + id + ' ps -e'
      describe command(execute_command) do
        its('stdout') { should_not match(/ssh/) }
      end
    end
  end
end

