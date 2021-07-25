control 'M-2.14' do
  title '2.14 Ensure live restore is Enabled (Scored)'
  desc  "The --live-restore enables full support of daemon-less containers in
  docker. It ensures that docker does not stop containers on shutdown or restore and properly
  reconnects to the container when restarted.
  One of the important security triads is availability. Setting --live-restore flag in the
  docker daemon ensures that container execution is not interrupted when the
  docker daemon is not available. This also means that it is now easier to update
  and patch the docker daemon without execution downtime.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.14'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run docker info and ensure that the Live Restore Enabled
  property is set to true. docker info --format '{{ .LiveRestoreEnabled
  }}' Alternatively run the below command and ensure that --live-restore is
  used. ps -ef | grep dockerd"
  tag "fix": "Run the docker in daemon mode and pass --live-restore as an
  argument. For Example, dockerd --live-restore"
  tag "Default Value": 'By default, --live-restore is not enabled.'
  ref 'live-restore', url: 'https://docs.docker.com/engine/admin/live-restore/'
  ref 'Add --live-restore flag', url: 'https://github.com/docker/docker/pull/23213'

  describe json('/etc/docker/daemon.json') do
    its(['live-restore']) { should eq(true) }
  end
end

