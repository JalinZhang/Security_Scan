control 'M-3.6' do
  title '3.6 Ensure that /etc/docker directory permissions are set to 755 or more restrictive (Scored)'
  desc  "Verify that the /etc/docker directory permissions are correctly set to 755 or more restrictive.
  The /etc/docker directory contains certificates and keys in addition to various
  sensitive files. Hence, it should only be writable by root to maintain the integrity of the directory.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/engine/security/https/'
  tag "severity": 'medium'
  tag "cis_id": '3.6'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Execute the below command to verify that the directory has
  permissions of 755 or more restrictive: stat -c %a /etc/docker"
  tag "fix": "chmod 755 /etc/docker This would set the permissions for the
  directory to 755."
  tag "Default Value": "By default, the permissions for this directory are
  correctly set to 755."
  ref url: 'https://docs.docker.com/engine/security/certificates/'

  describe file('/etc/docker') do
    it { should exist }
    it { should be_directory }
    it { should be_readable.by('owner') }
    it { should be_writable.by('owner') }
    it { should be_executable.by('owner') }
    it { should be_readable.by('group') }
    it { should_not be_writable.by('group') }
    it { should be_executable.by('group') }
    it { should be_readable.by('other') }
    it { should_not be_writable.by('other') }
    it { should be_executable.by('other') }
  end
end

