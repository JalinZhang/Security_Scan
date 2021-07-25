control 'M-3.17' do
  title '3.17 Ensure that the daemon.json file ownership is set to root:root(Scored)'
  desc  "Verify that the daemon.json file ownership and group-ownership is correctly set to root.
  The daemon.json file contains sensitive parameters that may alter the behavior of the docker
  daemon. Hence, it should be owned and group-owned by root to maintain the integrity of the file.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/dockerd/#daemonconfiguration-file"
  tag "severity": 'medium'
  tag "cis_id": '3.17'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the file is owned and
  group-owned by root: stat -c %U:%G /etc/docker/daemon.json | grep -v
  root:root The above command should not return anything."
  tag "fix": "chown root:root /etc/docker/daemon.json This would set the
  ownership and group-ownership for the file to root."
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable."
  ref url: 'https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file'

  describe file('/etc/docker/daemon.json') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

