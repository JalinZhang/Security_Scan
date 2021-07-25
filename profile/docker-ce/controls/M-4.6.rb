control 'M-4.6' do
  title '4.6 Ensure HEALTHCHECK instructions have been added to the container image (Scored)'
  desc  "Add HEALTHCHECK instruction in your docker container images to perform the
  health check on running containers. One of the important security triads is availability.
  Adding HEALTHCHECK instruction to your container image ensures that the docker engine
  periodically checks the running container instances against that instruction to ensure
  that the instances are still working.
  Based on the reported health status, the docker engine could then exit
  non-working containers and instantiate new ones.
  "
  impact 0.5
  tag "ref": '1. https://docs.docker.com/engine/reference/builder/#healthcheck'
  tag "severity": 'medium'
  tag "cis_id": '4.6'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run the below command and ensure that the docker image has
  appropriate HEALTHCHECK instruction set up. docker inspect --format='{{
  .Config.Healthcheck }}' <IMAGE>"
  tag "fix": "Follow Docker documentation and rebuild your container image with
  HEALTHCHECK instruction."
  tag "Default Value": 'By default, HEALTHCHECK is not set.'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{Config Healthcheck}) { should_not eq nil }
      end
    end
  end
end

