control 'M-2.18' do
  title '2.18 Ensure containers are restricted from acquiring new privileges(Scored)'
  desc  "Restrict containers from acquiring additional privileges via suid or sgid bits, by default.
  A process can set the no_new_priv bit in the kernel. It persists across
  fork, clone and execve. The no_new_priv bit ensures that the process or its children
  processes do not gain any additional privileges via suid or sgid bits. This way a lot of
  dangerous operations become a lot less dangerous because there is no possibility of subverting
  privileged binaries. Setting this at the daemon level ensures that by default all new containers
  are restricted from acquiring new privileges.
  "
  impact 0.5
  tag "ref": "1. https://github.com/moby/moby/pull/299842.
  https://github.com/moby/moby/pull/20727"
  tag "severity": 'medium'
  tag "cis_id": '2.18'
  tag "cis_control": ['5', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "ps -ef | grep dockerd Ensure that the --no-new-privileges
  parameter is present and is not set to false."
  tag "fix": 'Run the Docker daemon as below: dockerd --no-new-privileges'
  tag "Default Value": 'By default, containers are not restricted from acquiring new privileges.'
  describe 'A manaul review is required to ensure containers are restricted from acquiring new privileges' do
    skip 'A manaul review is required to ensure containers are restricted from acquiring new privileges'
  end
end

