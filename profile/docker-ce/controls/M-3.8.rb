control 'M-3.8' do
  title '3.8 Ensure that registry certificate file permissions are set to 444 or more restrictive (Scored)'
  desc  "Verify that all the registry certificate files (usually found under /etc/docker/certs.d/<registry-name> directory) have permissions of 444 or
  more restrictive. The /etc/docker/certs.d/<registry-name> directory contains Docker registry
  certificates. These certificate files must have permissions of 444 to maintain the
  integrity of the certificates.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/registry/insecure/'
  tag "severity": 'medium'
  tag "cis_id": '3.8'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Execute the below command to verify that the registry
  certificate files have permissions of 444 or more restrictive: stat -c %a
  /etc/docker/certs.d/<registry-name>/*"
  tag "fix": "chmod 444 /etc/docker/certs.d/<registry-name>/*This would set
  the permissions for registry certificate files to 444."
  tag "Default Value": "By default, the permissions for registry certificate
  files might not be 444. The default file permissions are governed by the
  system or user specific umaskvalues."
  ref url: 'https://docs.docker.com/engine/security/certificates/'
  ref url: 'docs.docker.com/reference/commandline/cli/#insecure-registries'

  describe file(attribute('registry_ca_file')) do
    it { should exist }
    it { should be_file }
    it { should be_readable }
    it { should_not be_executable }
    it { should_not be_writable }
  end
end

