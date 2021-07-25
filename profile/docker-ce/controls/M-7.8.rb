control 'M-7.8' do
  title '7.8 Ensure node certificates are rotated as appropriate (Not Scored)'
  desc  "Rotate swarm node certificates as appropriate.
  Docker Swarm uses mutual TLS for clustering operations amongst its nodes.
  Certificate rotation ensures that in an event such as a compromised node or key, it is
  difficult to impersonate a node. By default, node certificates are rotated every 90
  days. You should rotate them more often or as appropriate in your environment.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/swarm_update/#examples"
  tag "severity": 'medium'
  tag "cis_id": '7.8'
  tag "cis_control": ['14.2', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SC-8', '4']
  tag "check_text": "Run the below command and ensure that the node certificate
  Expiry Duration is set as appropriate. docker info | grep \"Expiry
  Duration\""
  tag "fix": "Run the below command to set the desired expiry time. For
  example, docker swarm update --cert-expiry 48h"
  tag "Default Value": 'By default, node certificates are rotated automatically every 90 days.'

  if attribute('swarm_mode') == 'active'
    swarm_root_ca_expiry = command('docker info | grep "Expiry Duration" ').stdout.strip
    describe "A manual review of the swarm root ca certificate expiry duration : #{swarm_root_ca_expiry} is required to ensure it is rotated as appropriate" do
      skip "A manual review of the swarm root ca certificate expiry duration : #{swarm_root_ca_expiry} is required to ensure it is rotated as appropriate"
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

