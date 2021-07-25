control 'M-6.2' do
  title '6.2 Ensure container sprawl is avoided (Not Scored)'
  desc  "Do not keep a large number of containers on the same host.
  The flexibility of containers makes it easy to run multiple instances of
  applications and indirectly leads to Docker images that exist at varying security patch
  levels. It also means that you are consuming host resources that otherwise could have been used
  for running 'useful' containers. Having more than just the manageable number of
  containers on a particular host makes the situation vulnerable to mishandling,
  misconfiguration and fragmentation. Thus, avoid container sprawl and keep the number of
  containers on a host to a manageable total.
  "
  impact 0.5
  tag "ref": "1.
  https://zeltser.com/security-risks-and-benefits-of-docker-application/2.
  http://searchsdn.techtarget.com/feature/Docker-networking-How-Linuxcontainers-will-change-your-network"
  tag "severity": 'medium'
  tag "cis_id": '6.2'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Step 1 - Find the total number of containers you have on the
  host: docker info --format '{{ .Containers }}' Step 2 - Execute the below
  commands to find the total number of containers that are actually running or
  in the stopped state on the host. docker info --format '{{ .ContainersStopped
  }}' docker info --format '{{ .ContainersRunning }}' If the difference between
  the number of containers that are stopped on the host and the number of
  containers that are actually running on the host is large (say 25 or more),
  then perhaps, the containers are sprawled on the host."
  tag "fix": "Periodically check your container inventory per host and clean up
  the stopped containers using the below command: docker container prune"
  tag "Default Value": "By default, Docker does not restrict the number of
  containers you may have on a host."
  ref 'https://zeltser.com/security-risks-and-benefits-of-docker-application/'
  ref 'http://searchsdn.techtarget.com/feature/Docker-networking-How-Linux-containers-will-change-your-network'

  total_on_host = command('docker info').stdout.split[1].to_i
  total_running = command('docker ps -q').stdout.split.length
  diff = total_on_host - total_running

  describe diff do
    it { should be <= attribute('managable_container_number') }
  end
end

