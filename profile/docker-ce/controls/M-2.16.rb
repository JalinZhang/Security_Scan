control 'M-2.16' do
  title '2.16 Ensure daemon-wide custom seccomp profile is applied, if needed (Not Scored)'
  desc  "You can choose to apply your custom seccomp profile at the daemon-wide
  level if needed and override Docker's default seccomp profile.
  A large number of system calls are exposed to every userland process with
  many of them going unused for the entire lifetime of the process. Most of the
  applications do not need all the system calls and thus benefit by having a reduced set of available
  system calls. The reduced set of system calls reduces the total kernel surface exposed to the
  application and thus improvises application security.
  You could apply your own custom seccomp profile instead of Docker's default
  seccomp profile. Alternatively, if Docker's default profile is good for your
  environment, you can choose to ignore this recommendation.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/engine/security/seccomp/\n2.
  https://github.com/docker/docker/pull/26276\n"
  tag "severity": 'medium'
  tag "cis_id": '2.16'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Run the below command and review the seccomp profile listed in
  the Security Options section. If it is default, that means, Docker's default
  seccomp profile is applied. docker info --format '{{ .SecurityOptions }}'"
  tag "fix": "By default, Docker's default seccomp profile is applied. If this
  is good for your environment, no action is necessary. Alternatively, if you
  choose to apply your own seccomp profile, use the --seccomp-profile flag at
  daemon start or put it in the daemon runtime parameters file.dockerd
  --seccomp-profile </path/to/seccomp/profile>"
  tag "Default Value": 'By default, Docker applies a seccomp profile.'
  seccomp_profile = command("docker info --format '{{ .SecurityOptions }}'").stdout.strip
  describe 'The docker seccommp profile applied' do
    subject { seccomp_profile }
    it { should_not include 'name=seccomp,profile=default' }
  end

end

