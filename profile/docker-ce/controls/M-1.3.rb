control 'M-1.3' do
  title '1.3 Ensure Docker is up to date (Not Scored)'
  desc  "
  There are frequent releases for Docker software that address security vulnerabilities,
  product bugs and bring in new functionality. Keep a tab on these product
  updates and upgrade as frequently as when new security vulnerabilities are fixed or
  deemed correct for your organization.
  By staying up to date on Docker updates, vulnerabilities in the Docker
  software can be mitigated. An educated attacker may exploit known vulnerabilities when
  attempting to attain access or elevate privileges. Not installing regular Docker updates
  may leave you running vulnerable Docker software. It might lead to elevation
  privileges, unauthorized access or other security breaches. Keep a track of new
  releases and update as necessary.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.3'
  tag "cis_control": ['4', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['RA-5', '4']
  tag "check_text": "Execute the below command and verify that the Docker version is
  up to date as deemed necessary. It is not a mandate to be on the latest one,
  though. docker version"
  tag "fix": 'Keep a track of Docker releases and update as necessary.'
  tag "Default Value": 'Not Applicable'
  ref 'installation', url: 'https://docs.docker.com/engine/installation/'
  ref 'latest', url: 'https://github.com/moby/moby/releases/latest'
  ref 'latest', url: 'https://github.com/docker/docker-ce/releases/latest'
  ref 'Docker installation', url: 'https://docs.docker.com/installation/'
  ref 'Docker releases', url: 'https://github.com/docker/docker/releases/latest'

  describe docker.version do
    its('Client.Version') { should cmp >= '17.03' }
    its('Server.Version') { should cmp >= '17.03' }
  end
end

