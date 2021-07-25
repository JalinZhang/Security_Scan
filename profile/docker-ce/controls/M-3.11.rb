control 'M-3.11' do
  title '3.11 Ensure that Docker server certificate file ownership is set to root:root (Scored)'
  desc  "Verify that the Docker server certificate file (the file that is passed along with the --tlscert
  parameter) is owned and group-owned by root.
  The Docker server certificate file should be protected from any tampering.
  It is used to authenticate the Docker server based on the given server certificate. Hence, it
  must be owned and group-owned by root to maintain the integrity of the certificate.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/registry/insecure/2.
  https://docs.docker.com/engine/security/https/"
  tag "severity": 'medium'
  tag "cis_id": '3.11'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the Docker server
  certificate file is owned and group-owned by root: stat -c %U:%G <path to
  Docker server certificate file> | grep -v root:root The above command should
  not return anything."
  tag "fix": "chown root:root <path to Docker server certificate file> This
  would set the ownership and group-ownership for the Docker server certificate
  file to root."
  tag "Default Value": "By default, the ownership and group-ownership for
  Docker server certificate file is correctly set to root."
  ref url: 'https://docs.docker.com/engine/security/certificates/'
  ref url: 'https://docs.docker.com/engine/security/https/'

  describe file(json('/etc/docker/daemon.json').params['tlscert']) do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

