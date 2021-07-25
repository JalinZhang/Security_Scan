control 'M-3.7' do
  title '3.7 Ensure that registry certificate file ownership is set to root:root(Scored)'
  desc  "Verify that all the registry certificate files (usually found under
  the /etc/docker/certs.d/<registry-name> directory) are owned and group-owned by root.
  The /etc/docker/certs.d/<registry-name> directory contains Docker registry certificates.
  These certificate files must be owned and group-owned by root to maintain
  the integrity of the certificates.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/registry/insecure/'
  tag "severity": 'medium'
  tag "cis_id": '3.7'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the registry
  certificate files are owned and group-owned by root: stat -c %U:%G
  /etc/docker/certs.d/* | grep -v root:root The above command should not return
  anything."
  tag "fix": "chown root:root /etc/docker/certs.d/<registry-name>/* This would
  set the ownership and group-ownership for the registry certificate files to root."
  tag "Default Value": "By default, the ownership and group-ownership for
  registry certificate files is correctly set to root."
  ref url: 'https://docs.docker.com/engine/security/certificates/'
  ref url: 'docs.docker.com/reference/commandline/cli/#insecure-registries'

  describe file(attribute('registry_cert_path')) do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file(attribute('registry_name')) do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file(attribute('registry_ca_file')) do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

