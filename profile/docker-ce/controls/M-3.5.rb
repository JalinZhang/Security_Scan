control 'M-3.5' do
  title '3.5 Ensure that /etc/docker directory ownership is set to root:root(Scored)'
  desc  "Verify that the /etc/docker directory ownership and group-ownership is
  correctly set to root. The /etc/docker directory contains certificates and keys in
  addition to various sensitive files. Hence, it should be owned and group-owned by root to
  maintain the integrity of the directory.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.5'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the directory is owned
  and group-owned by root: stat -c %U:%G /etc/docker | grep -v root:root The
  above command should not return anything."
  tag "fix": "chown root:root /etc/docker This would set the ownership and
  group-ownership for the directory to root."
  tag "Default Value": "By default, the ownership and group-ownership for this
  directory is correctly set to root."
  ref 'certificates', url: 'https://docs.docker.com/engine/security/certificates/'
  ref 'https', url: 'https://docs.docker.com/engine/security/https/'

  describe file('/etc/docker') do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

