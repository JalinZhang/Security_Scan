control 'M-7.2' do
  title '7.2 Ensure the minimum number of manager nodes have been created in a swarm (Scored)'
  desc  "Ensure that the minimum number of required manager nodes is created in a
  swarm. Manager nodes within a swarm have control over the swarm and change its
  configuration modifying security parameters. Having excessive manager nodes could render
  the swarm more susceptible to compromise.
  If fault tolerance is not required in the manager nodes, a single node
  should be elected as a manger. If fault tolerance is required then the smallest practical odd
  number to achieve the appropriate level of tolerance should be configured.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/swarm/manage-nodes/2.
  https://docs.docker.com/engine/swarm/admin_guide/#/add-manager-nodes-forfault-tolerance"
  tag "severity": 'medium'
  tag "cis_id": '7.2'
  tag "cis_control": ['5', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "Run docker info and verify the number of managers. docker info
  --format '{{ .Swarm.Managers }}' Alternatively run the below command. docker
  node ls | grep 'Leader'"
  tag "fix": "If an excessive number of managers is configured, the excess can
  be demoted as workers using the following command: docker node demote
  <ID> Where ID the node ID value of the manager to be demoted."
  tag "Default Value": 'A single manager is all that is required to start a given cluster.'
  ref 'manage-nodes', url: 'https://docs.docker.com/engine/swarm/manage-nodes/'
  ref 'add-manager-nodes-forfault-tolerance', url: 'https://docs.docker.com/engine/swarm/admin_guide/#/add-manager-nodes-forfault-tolerance'
  if attribute('swarm_mode') == 'active'
    describe docker.info do
      its('Swarm.Managers') { should cmp <= attribute('swarm_max_manager_nodes') }
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

