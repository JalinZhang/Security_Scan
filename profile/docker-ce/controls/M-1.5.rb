control 'M-1.5' do
  title '1.5 Ensure auditing is configured for the docker daemon (Scored)'
  desc  "Audit all Docker daemon activities.
  Apart from auditing your regular Linux file system and system calls, audit
  Docker daemon as well. Docker daemon runs with root privileges. It is thus necessary to
  audit its activities and usage.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.5'
  tag "cis_control": ['6.2', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AU-3', '4']
  tag "check_text": "Verify that there is an audit rule for Docker daemon. For
  example, execute below command: auditctl -l | grep /usr/bin/docker This
  should list a rule for Docker daemon."
  tag "fix": "Add a rule for Docker daemon. For example, Add the line as
  below line in /etc/audit/audit.rules file: -w /usr/bin/docker -k docker Then,
  restart the audit daemon. For example, service auditd restart"
  tag "Default Value": 'By default, Docker daemon is not audited.'
  ref 'System auditing', url: 'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/chap-system_auditing.html'

  only_if { os.linux? }
  describe auditd do
    its('lines') { should include '-w /usr/bin/docker -p rwxa -k docker' }
  end
  describe service('auditd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

