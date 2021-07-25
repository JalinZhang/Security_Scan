control 'M-5.22' do
  title '5.22 Ensure docker exec commands are not used with privileged option(Scored)'
  desc  "Do not use docker exec with the --privileged option.
  Using the --privileged option in docker exec gives extended Linux capabilities
  to the command. This could potentially be insecure and unsafe to do especially
  when you are running containers with dropped capabilities or with enhanced restrictions.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/reference/commandline/exec/\n"
  tag "severity": 'medium'
  tag "cis_id": '5.22'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "If you have auditing enabled as prescribed in Section 1, you
  can use the below command to filter out docker exec commands that used
  the --privileged option. ausearch -k docker | grep exec | grep privileged"
  tag "fix": 'Do not use the --privileged option in the docker exec command.'
  tag "Default Value": "By default, the docker exec command runs without the
  --privileged option."
  ref url: 'https://docs.docker.com/engine/reference/commandline/exec/'

  describe command('ausearch --input-logs -k docker | grep exec | grep privileged').stdout do
    it { should be_empty }
  end
end

