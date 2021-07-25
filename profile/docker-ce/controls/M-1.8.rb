control 'M-1.8' do
  title "1.8 Ensure auditing is configured for Docker files and directories
  docker.service (Scored)"
  desc  "Audit docker.service, if applicable.
  Apart from auditing your regular Linux file system and system calls, audit
  all Docker related files and directories. Docker daemon runs with root privileges. Its
  behavior depends on some key files and directories. docker.service is one such file.
  The docker.service file might be present if the daemon parameters have been
  changed by an administrator. It holds various parameters for Docker daemon. It must be
  audited, if applicable.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.8'
  tag "cis_control": ['14.6', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AU-2', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.service Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, verify that there is an
  audit rule corresponding to the file: For example, execute the below
  command: auditctl -l | grep docker.service This should list a rule for
  docker.service as per its location."
  tag "fix": "If the file exists, add a rule for it. For example, Add the
  line as below in /etc/audit/audit.rules file: -w
  /usr/lib/systemd/system/docker.service -k docker Then, restart the audit
  daemon. For example, service auditd restart"
  tag "Default Value": "By default, Docker related files and directories are
  not audited. The file docker.service may not be available on the system."
  ref 'System auditing', url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html'
  docker_service_file = command('systemctl show -p FragmentPath docker.service').stdout.strip

  equal_sign = docker_service_file.index('=')

  docker_service_file = docker_service_file[equal_sign+1..-1]

  if file(docker_service_file.to_s).exist?

    describe auditd  do
      its('lines') { should include "-w #{docker_service_file} -k docker" }
    end

  else
    impact 0.0
    describe 'The docker service file does not exist, therefore this control is N/A' do
      skip 'The docker service file does not exist, therefore this control is N/A'
    end
  end

end

