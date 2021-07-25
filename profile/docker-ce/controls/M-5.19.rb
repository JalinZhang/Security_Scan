control 'M-5.19' do
  title '5.19 Ensure mount propagation mode is not set to shared (Scored)'
  desc  "Mount propagation mode allows mounting volumes in shared, slave or private
  mode on a container. Do not use shared mount propagation mode until needed.
  A shared mount is replicated at all mounts and the changes made at any
  mount point are propagated to all mounts. Mounting a volume in shared mode does not
  restrict any other container to mount and make changes to that volume. This might be
  catastrophic if the mounted volume is sensitive to changes. Do not set mount propagation mode
  to shared until needed.
  "
  impact 0.5
  tag "ref": "1. https://github.com/docker/docker/pull/170342.
  https://docs.docker.com/engine/reference/run/#volume-shared-filesystems3.
  https://www.kernel.org/doc/Documentation/filesystems/sharedsubtree.txt"
  tag "severity": 'medium'
  tag "cis_id": '5.19'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}:Propagation={{range $mnt := .Mounts}} {{json $mnt.Propagation}}
  {{end}}' The above command would return the propagation mode for mounted
  volumes. Propagation mode should not be set to shared unless needed. The above
  command might throw errors if there are no mounts. In that case, this
  recommendation is not applicable."
  tag "fix": "Do not mount volumes in shared mode propagation. For example, do
  not start container as below: docker run <Run arguments>
  --volume=/hostPath:/containerPath:shared <Container Image Name or ID>
  <Command>"
  tag "Default Value": 'By default, the container mounts are private.'
  ref url: 'https://github.com/docker/docker/pull/17034'
  ref url: 'https://docs.docker.com/engine/reference/run/'
  ref url: 'https://www.kernel.org/doc/Documentation/filesystems/sharedsubtree.txt'

  if docker.containers.running?.ids.empty?
    impact 0.0
    describe 'There are no running docker containers, therfore this control is N/A' do
      skip 'There are no running docker containers, therfore this control is N/A'
    end
  end

  if !docker.containers.running?.ids.empty?
    docker.containers.running?.ids.each do |id|
      raw = command("docker inspect --format '{{range $mnt := .Mounts}} {{json $mnt.Propagation}} {{end}}' #{id}").stdout
      describe raw.delete("\n").delete('\"').delete(' ') do
        it { should_not eq 'shared' }
      end
    end
  end
end

