control 'M-1.6' do
  title "1.6 Ensure auditing is configured for Docker files and directories
  /var/lib/docker (Scored)"
  desc  "Audit /var/lib/docker.
  Apart from auditing your regular Linux file system and system calls, audit
  all Docker related files and directories. Docker daemon runs with root privileges. Its
  behavior depends on some key files and directories. /var/lib/docker is one such
  directory. It holds all the information about containers. It must be audited.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.6'
  tag "cis_control": ['14.6', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AU-2', '4']
  tag "check_text": "Verify that there is an audit rule corresponding to
  /var/lib/docker directory. For example, execute below command: auditctl -l |
  grep /var/lib/docker This should list a rule for /var/lib/docker directory."
  tag "fix": "Add a rule for /var/lib/docker directory. For example, Add the
  line as below in /etc/audit/audit.rules file: -w /var/lib/docker -k
  docker Then, restart the audit daemon. For example, service auditd restart"
  tag "Default Value": "By default, Docker related files and directories are
  not audited."
  ref 'System auditing', url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html'

  describe auditd do
    its('lines') { should include '-w /var/lib/docker/ -p rwxa -k docker' }
  end
end

