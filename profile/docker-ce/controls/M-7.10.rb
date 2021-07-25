SWARM_MODE = attribute(
  'swarm_mode',
  description: 'define the swarm mode, `active` or `inactive`',
  default: 'inactive',
)

control 'M-7.10' do
  title '7.10 Ensure management plane traffic has been separated from data plane traffic (Not Scored)'
  desc  "Separate management plane traffic from data plane traffic.
  Separating the management plane traffic from data plane traffic ensures
  that these traffics are on their respective paths. These paths could then be individually
  monitored and could be tied to different traffic control policies and monitoring. It also
  ensures that the management plane is always reachable despite the huge volume of data flow.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/swarm_init/#--datapath-addr2.
  https://github.com/moby/moby/issues/339383.
  https://github.com/moby/moby/pull/32717"
  tag "severity": 'medium'
  tag "cis_id": '7.10'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run the below command on each swarm node and ensure that the
  management plane address is different from data plane address. docker node
  inspect --format '{{ .Status.Addr }}' self Note: At the time of writing of
  this benchmark, there is no way to inspect the data plane address. An issue has
  been raised and is in the reference link."
  tag "fix": "Initialize Swarm with dedicated interfaces for management and
  data planes respectively. For example, docker swarm init
  --advertise-addr=192.168.0.1 --data-path-addr=17.1.0.3"
  tag "Default Value": "By default, the data plane traffic is not separated
  from management plane traffic."

  if attribute('swarm_mode') == 'active'
    describe 'A manual review is required to ensure management plane traffic has been separated from data plane traffic' do
      skip 'A manual review is required to ensure management plane traffic has been separated from data plane traffic'
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

