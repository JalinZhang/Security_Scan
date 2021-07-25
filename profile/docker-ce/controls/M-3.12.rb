control 'M-3.12' do
  title '3.12 Ensure that the Docker server certificate file permissions are set to 444 or more restrictive (Scored)'
  desc  "Verify that the Docker server certificate file (the file that is passed
  along with the --tlscert parameter) has permissions of 444 or more restrictive.
  The Docker server certificate file should be protected from any tampering.
  It is used to the authenticate Docker server based on the given server certificate. Hence, it
  must have permissions of 444 to maintain the integrity of the certificate.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/registry/insecure/2.
  https://docs.docker.com/engine/security/https/"
  tag "severity": 'medium'
  tag "cis_id": '3.12'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Execute the below command to verify that the Docker server
  certificate file has permissions of 444 or more restrictive: stat -c %a <path
  to the Docker server certificate file>"
  tag "fix": "chmod 444 <path to the Docker server certificate file> This would
  set the file permissions of the Docker server file to 444."
  tag "Default Value": "By default, the permissions for Docker server
  certificate file might not be 444. The default file permissions are governed
  by the system or user specific umask values."
  ref url: 'https://docs.docker.com/engine/security/certificates/'
  ref url: 'https://docs.docker.com/engine/security/https/'

  describe file(json('/etc/docker/daemon.json').params['tlscert']) do
    it { should exist }
    it { should be_file }
    it { should be_readable }
    it { should_not be_executable }
    it { should_not be_writable }
  end
end

