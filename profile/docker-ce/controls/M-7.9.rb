SWARM_MODE = attribute(
  'swarm_mode',
  description: 'define the swarm mode, `active` or `inactive`',
  default: 'inactive',
)

control 'M-7.9' do
  title '7.9 Ensure CA certificates are rotated as appropriate (Not Scored)'
  desc  "Rotate root CA certificates as appropriate.
  Docker Swarm uses mutual TLS for clustering operations amongst its nodes.
  Certificate rotation ensures that in an event such as a compromised node or key, it is
  difficult to impersonate a node. Node certificates depend upon root CA certificates. For
  operational security, it is important to rotate these frequently. Currently, root CA
  certificates are not rotated automatically. You should thus establish a process to rotate it at
  the desired frequency.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/swarm/how-swarm-mode-works/pki/#rotatingthe-ca-certificate"
  tag "severity": 'medium'
  tag "cis_id": '7.9'
  tag "cis_control": ['14.2', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SC-8', '4']
  tag "check_text": "Based on your installation path, check the time stamp on the
  root CA certificate file. For example, ls -l
  /var/lib/docker/swarm/certificates/swarm-root-ca.crt The certificate should
  have been rotated at the established frequency."
  tag "fix": 'Run the below command to rotate the certificate. docker swarm ca --rotate'
  tag "Default Value": 'By default, root CA certificates are not rotated.'

  if attribute('swarm_mode') == 'active'
    swarm_root_ca_crt = command('ls -l /var/lib/docker/swarm/certificates/swarm-root-ca.crt').stdout.strip
    describe "A manual review of the swarm root ca certificate: #{swarm_root_ca_crt} is required to ensure it is rotated as appropriate" do
      skip "A manual review of the swarm root ca certificate: #{swarm_root_ca_crt} is required to ensure it is rotated as appropriate"
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

