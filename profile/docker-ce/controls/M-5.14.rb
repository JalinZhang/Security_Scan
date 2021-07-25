control 'M-5.14' do
  title "5.14 Ensure 'on-failure' container restart policy is set to '5' (Scored)"
  desc  "Using the --restart flag in the docker run command you can specify a restart
  policy for how a container should or should not be restarted on exit. You should choose the
  on-failure restart policy and limit the restart attempts to 5.
  If you indefinitely keep trying to start the container, it could possibly
  lead to a denial of service on the host. It could be an easy way to do a distributed denial of
  service attack especially if you have many containers on the same host. Additionally,
  ignoring the exit status of the container and always attempting to restart the container
  leads to noninvestigation of the root cause behind containers getting
  terminated. If a container gets terminated, you should investigate the reason behind it
  instead of just attempting to restart it indefinitely. Thus, it is recommended to the
  use on-failure restart policy and limit it to maximum of 5 restart attempts.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/run/#restart-policiesrestart"
  tag "severity": 'medium'
  tag "cis_id": '5.14'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: RestartPolicyName={{ .HostConfig.RestartPolicy.Name }}
  MaximumRetryCount={{.HostConfig.RestartPolicy.MaximumRetryCount }}' If
  the above command returns RestartPolicyName=always, then the system is
  not configured as desired and hence this recommendation is non-compliant. If
  the above command returns RestartPolicyName=no or just
  RestartPolicyName=, then the restart policies are not being used and the
  container would never be restarted of its own. This recommendation is then Not
  Applicable and can be assumed to be compliant. If the above command returns
  RestartPolicyName=on-failure, then verify that the number of restart attempts
  is set to 5 or less by looking at MaximumRetryCount."
  tag "fix": "If a container is desired to be restarted of its own, then, for
  example, you could start the container as below: docker run --detach
  --restart=on-failure:5 nginx"
  tag "Default Value": "By default, containers are not configured with restart
  policies. Hence, containers do not attempt to restart on their own."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#restart-policies'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe.one do
        describe docker.object(id) do
          its(%w{HostConfig RestartPolicy Name}) { should eq 'no' }
        end
        describe docker.object(id) do
          its(%w{HostConfig RestartPolicy Name}) { should eq 'on-failure' }
          its(%w{HostConfig RestartPolicy MaximumRetryCount}) { should eq 5 }
        end
      end
    end
  end
end

