control 'M-5.25' do
  title '5.25 Ensure the container is restricted from acquiring additional privileges (Scored)'
  desc  "Restrict the container from acquiring additional privileges via suid or
  sgid bits. A process can set the no_new_priv bit in the kernel. It persists across
  fork, clone and execve. The no_new_priv bit ensures that the process or its children
  processes do not gain any additional privileges via suid or sgid bits. This way a lot of
  dangerous operations become a lot less dangerous because there is no possibility of subverting
  privileged binaries.
  "
  impact 0.5
  tag "ref": "1.
  https://github.com/projectatomic/atomic-site/issues/2692.3.4.5. https://github.com/docker/docker/pull/20727 https://www.kernel.org/doc/Documentation/prctl/no_new_privs.txt https://lwn.net/Articles/475678/ https://lwn.net/Articles/475362/"
  tag "severity": 'medium'
  tag "cis_id": '5.25'
  tag "cis_control": ['5', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: SecurityOpt={{ .HostConfig.SecurityOpt }}' The above command should
  return all the security options currently configured for the containers.
  no-new-privileges should also be one of them."
  tag "fix": "For example, you should start your container as below: docker
  run --rm -it --security-opt=no-new-privileges ubuntu bash"
  tag "Default Value": 'By default, new privileges are not restricted.'
  ref url: 'https://github.com/projectatomic/atomic-site/issues/269'
  ref url: 'https://github.com/docker/docker/pull/20727'
  ref url: 'https://www.kernel.org/doc/Documentation/prctl/no_new_privs.txt'
  ref url: 'https://lwn.net/Articles/475678/'
  ref url: 'https://lwn.net/Articles/475362/'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig SecurityOpt}) { should include(/no-new-privileges/) }
      end
    end
  end
end

