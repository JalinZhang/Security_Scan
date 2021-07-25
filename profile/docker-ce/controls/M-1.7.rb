control 'M-1.7' do
  title "1.7 Ensure auditing is configured for Docker files and directories
  /etc/docker (Scored)"
  desc  "Audit /etc/docker.
  Apart from auditing your regular Linux file system and system calls, audit
  all Docker related files and directories. Docker daemon runs with root privileges. Its
  behavior depends on some key files and directories. /etc/docker is one such
  directory. It holds various certificates and keys used for TLS communication between Docker
  daemon and Docker client. It must be audited.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.7'
  tag "cis_control": ['14.6', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AU-2', '4']
  tag "check_text": "Verify that there is an audit rule corresponding to /etc/docker
  directory. For example, execute below command: auditctl -l | grep
  /etc/docker This should list a rule for /etc/docker directory."
  tag "fix": "Add a rule for /etc/docker directory. For example, Add the line
  as below in /etc/audit/audit.rules file: -w /etc/docker -k docker Then,
  restart the audit daemon. For example, service auditd restart"
  tag "Default Value": "By default, Docker related files and directories are
  not audited."
  ref 'System auditing', url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html'

  describe auditd  do
    its('lines') { should include '-w /etc/docker/ -p rwxa -k docker' }
  end
end

