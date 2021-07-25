control 'M-1.9' do
  title "1.9 Ensure auditing is configured for Docker files and directories
  docker.socket (Scored)"
  desc  "
  Audit docker.socket, if applicable.
  Apart from auditing your regular Linux file system and system calls, audit
  all Docker related files and directories. Docker daemon runs with root privileges. Its
  behavior depends on some key files and directories. docker.socket is one such file.
  It holds various parameters for Docker daemon socket. It must be audited, if applicable.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.9'
  tag "cis_control": ['14.6', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AU-2', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.socket Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, verify that there is an
  audit rule corresponding to the file: For example, execute the below
  command: auditctl -l | grep docker.socket This should list a rule for
  docker.socket as per its location."
  tag "fix": "If the file exists, add a rule for it. For example, Add the
  line as below in /etc/audit/audit.rules file: -w
  /usr/lib/systemd/system/docker.socket -k docker Then, restart the audit
  daemon. For example, service auditd restart"
  tag "Default Value": "By default, Docker related files and directories are
  not audited. The file docker.socket may not be available on the system."
  ref 'System auditing', url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html'

  docker_socket_file = command('systemctl show -p FragmentPath docker.socket').stdout.strip

  equal_sign = docker_socket_file.index('=')

  docker_socket_file = docker_socket_file[equal_sign+1..-1]

  if file(docker_socket_file.to_s).exist?

    describe auditd  do
      its('lines') { should include "-w #{docker_socket_file} -k docker" }
    end

  else
    impact 0.0
    describe 'The docker socket file does not exist, therefore this control is N/A' do
      skip 'The docker socket file does not exist, therefore this control is N/A'
    end
  end
end

