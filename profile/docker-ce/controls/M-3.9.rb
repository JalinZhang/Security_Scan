control 'M-3.9' do
  title "3.9 Ensure that TLS CA certificate file ownership is set to
  root:root(Scored)"
  desc "Verify that the TLS CA certificate file (the file that is passed along with the
  --tlscacert parameter) is owned and group-owned by root.
  The TLS CA certificate file should be protected from any tampering. It is
  used to authenticate the Docker server based on given CA certificate. Hence, it must be
  owned and group-owned by root to maintain the integrity of the CA certificate.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/registry/insecure/2.
  https://docs.docker.com/engine/security/https/"
  tag "severity": 'medium'
  tag "cis_id": '3.9'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Execute the below command to verify that the TLS CA certificate
  file is owned and group owned by root: stat -c %U:%G <path to the TLS CA
  certificate file> | grep -v root:root The above command should not return
  anything."
  tag "fix": "chown root:root <path to the TLS CA certificate file> This would set
  the ownership and group-ownership for the TLS CA certificate file to root."
  tag "Default Value": "By default, the ownership and group-ownership for the TLS
  CA certificate file is correctly set to root."
  ref url: 'https://docs.docker.com/engine/security/certificates/'
  ref url: 'https://docs.docker.com/engine/security/https/'

  json('/etc/docker/daemon.json').params['tlscacert']

  describe file(json('/etc/docker/daemon.json').params['tlscacert']) do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

