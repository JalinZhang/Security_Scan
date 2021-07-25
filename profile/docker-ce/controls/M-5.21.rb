control 'M-5.21' do
  title '5.21 Ensure the default seccomp profile is not Disabled (Scored)'
  desc  "Seccomp filtering provides a means for a process to specify a filter for
  incoming system calls. The default Docker seccomp profile works on whitelist basis and
  allows 311 system calls and blocks all others. It should not be disabled unless it hinders your
  container application usage. A large number of system calls are exposed to every user and process with
  many of them going unused for the entire lifetime of the process. Most of the
  applications do not need all the system calls and thus benefit by having a reduced set of available
  system calls. The reduced set of system calls reduces the total kernel surface exposed to the
  application and thus improvises application security.
  "
  impact 0.5
  tag "ref": "1.
  http://blog.scalock.com/new-docker-security-features-and-what-they-meanseccomp-profiles2.
  https://docs.docker.com/engine/reference/run/#security-configuration3.
  https://github.com/docker/docker/blob/master/profiles/seccomp/default.json4.
  https://docs.docker.com/engine/security/seccomp/5.
  https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt6.
  https://github.com/docker/docker/issues/22870"
  tag "severity": 'medium'
  tag "cis_id": '5.21'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}: SecurityOpt={{ .HostConfig.SecurityOpt }}' The above command should
  return <no value> or your modified seccomp profile. If it returns
  [seccomp:unconfined], that means this recommendation is non-compliant and
  the container is running without any seccomp profiles."
  tag "fix": "By default, seccomp profiles are enabled. You do not need to do
  anything unless you want to modify and use the modified seccomp profile."
  tag "Default Value": "When you run a container, it uses the default profile
  unless you override it with the -security-opt option."
  ref url: 'https://docs.docker.com/engine/reference/run/'
  ref url: 'http://blog.aquasec.com/new-docker-security-features-and-what-they-mean-seccomp-profiles'
  ref url: 'https://github.com/docker/docker/blob/master/profiles/seccomp/default.json'
  ref url: 'https://docs.docker.com/engine/security/seccomp/'
  ref url: 'https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt'
  ref url: 'https://github.com/docker/docker/pull/17034'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig SecurityOpt}) { should include(/seccomp/) }
        its(%w{HostConfig SecurityOpt}) { should_not include(/seccomp[=|:]unconfined/) }
      end
    end
  end
end

