control 'M-7.7' do
  title '7.7 Ensure swarm manager auto-lock key is rotated periodically (Not Scored)'
  desc  "Rotate the swarm manager auto-lock key periodically.
  The swarm manager auto-lock key is not automatically rotated. You should rotate
  them periodically as a best practice.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/swarm_unlock-key/"
  tag "severity": 'medium'
  tag "cis_id": '7.7'
  tag "cis_control": ['14.2', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SC-8', '4']
  tag "check_text": "Currently, there is no mechanism to find out when the key was
  last rotated on a swarm manager node. You should check with the system
  administrator to see if there is a key rotation record and whether the keys were rotated at a
  pre-defined frequency."
  tag "fix": "Run the below command to rotate the keys. docker swarm
  unlock-key --rotate Additionally, to facilitate an audit for this recommendation,
  maintain key rotation records and ensure that you establish a pre-defined
  frequency for key rotation."
  tag "Default Value": 'By default, keys are not rotated automatically.'
  if attribute('swarm_mode') == 'active'
    describe 'A manual review is required to ensure the swarm manager auto-lock key is rotated periodically' do
      skip 'A manual review is required to ensure the swarm manager auto-lock key is rotated periodically'
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

