control 'M-5.26' do
  title '5.26 Ensure container health is checked at runtime (Scored)'
  desc  "If the container image does not have a HEALTHCHECK instruction defined,
  use the --health-cmd parameter at container runtime for checking container health.
  One of the important security triads is availability. If the container
  image you are using does not have a pre-defined HEALTHCHECK instruction, use the --health-cmd
  parameter to check the container health at runtime.
  Based on the reported health status, you could take necessary actions.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/engine/reference/run/#healthcheck'
  tag "severity": 'medium'
  tag "cis_id": '5.26'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run the below command and ensure that all the containers are
  reporting health status: docker ps --quiet | xargs docker inspect --format '{{
  .Id }}: Health={{.State.Health.Status }}'"
  tag "fix": "Run the container using the --health-cmd and the other
  parameters. For example, docker run -d --health-cmd='stat /etc/passwd || exit
  1' nginx"
  tag "Default Value": "By default, health checks are not done at container
  runtime."

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      get_health = command("docker inspect --format='{{json .State.Health.Status}}' #{id}").stdout.strip.split('"')

      describe "The docker container health check status" do
        subject {get_health}
        it { should_not be_empty }
      end
      if !get_health.empty?
        get_health.each do |health_status|
          health_status.chomp('"\\"')
          describe "The docker container health check for container #{id}" do
            subject { health_status }
            it { should cmp 'healthy' }
          end
        end
      end
    end
  end
  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no docker containers running, therefore this control is N/A' do
      skip 'There are no docker containers running, therefore this control is N/A'
    end
  end
end



