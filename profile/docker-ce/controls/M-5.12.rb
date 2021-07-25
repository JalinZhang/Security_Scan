control 'M-5.12' do
  title "5.12 Ensure the container's root filesystem is mounted as read only(Scored)"
  desc  "The container's root filesystem should be treated as a 'golden image' by
  using Docker run's --read-only option. This prevents any writes to the container's root
  filesystem at container runtime and enforces the principle of immutable infrastructure.
  Enabling this option forces containers at runtime to explicitly define their data writing
  strategy to persist or not persist their data. This also reduces security attack vectors since
  the container instance's filesystem cannot be tampered with or written to unless it has explicit
  read-write permissions on its filesystem folder and directories.
  "
  impact 0.5
  tag "ref": "1. http://docs.docker.com/reference/commandline/cli/#run2.
  https://docs.docker.com/engine/tutorials/dockervolumes/3.
  http://www.projectatomic.io/blog/2015/12/making-docker-images-write-only-inproduction/4.
  https://docs.docker.com/engine/reference/commandline/run/#mount-tmpfstmpfs5.
  https://docs.docker.com/engine/tutorials/dockervolumes/#creating-andmounting-a-data-volume-container"
  tag "severity": 'medium'
  tag "cis_id": '5.12'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "Run the following command on the docker host: docker ps
  --quiet --all | xargs docker inspect --format '{{ .Id }}: ReadonlyRootfs={{
  .HostConfig.ReadonlyRootfs }}' If the above command returns true, it means the
  container's root filesystem is mounted read-only. If the above command
  returns false, it means the container's root filesystem is writable."
  tag "fix": "Add a --read-only flag at a container's runtime to enforce the
  container's root filesystem to be mounted as read only. docker run <Run
  arguments> --read-only <Container Image Name or ID> <Command> Enabling the
  --read-only option at a container's runtime should be used by
  administrators to force a container's executable processes to only write
  container data to explicit storage locations during the container's
  runtime. Examples of explicit storage locations during a container's runtime
  include, but not limited to: 1. Use the --tmpfs option to mount a temporary
  file system for non-persistent data writes. docker run --interactive --tty
  --read-only --tmpfs \"/run\" --tmpfs \"/tmp\" centos /bin/bash2. Enabling
  Docker rw mounts at a container's runtime to persist container data directly
  on the Docker host filesystem. docker run --interactive --tty --read-only -v
  /opt/app/data:/run/app/data:rw centos /bin/bash3. Utilizing Docker
  shared-storage volume plugins for Docker data volume to persist container
  data. docker volume create -d convoy --opt o=size=20GB my-named-volume docker
  run --interactive --tty --read-only -v my-named-volume:/run/app/data centos
  /bin/bash3. Transmitting container data outside of the docker during the
  container's runtime for container data to persist container data. Examples
  include hosted databases, network file shares, and APIs."
  tag "Default Value": "By default, a container will have its root filesystem
  writable allowing all container processes to write files owned by the
  container's runtime user."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#run'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      describe docker.object(id) do
        its(%w{HostConfig ReadonlyRootfs}) { should eq true }
      end
    end
  end
end

