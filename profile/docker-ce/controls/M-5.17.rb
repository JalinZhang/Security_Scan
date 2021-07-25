control 'M-5.17' do
  title '5.17 Ensure host devices are not directly exposed to containers (Not Scored)'
  desc  "Host devices can be directly exposed to containers at runtime. Do not
  directly expose host devices to containers especially for containers that are not trusted.
  The --device option exposes the host devices to the containers and
  consequently, the containers can directly access such host devices. You would not require the
  container to run in privileged mode to access and manipulate the host devices. By
  default, the container will be able to read, write and mknod these devices.
  Additionally, it is possible for containers to remove block devices from the host.
  Hence, do not expose host devices to the containers directly.
  If at all, you would want to expose the host device to a container, use the
  sharing permissions appropriately:
  r - read only
  w - writable
  m - mknod allowed
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/run/#options"
  tag "severity": 'medium'
  tag "cis_id": '5.17'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "docker ps --quiet --all | xargs docker inspect --format '{{ .Id
  }}:Devices={{ .HostConfig.Devices }}'The above command would list out each
  device with below information:CgroupPermissions - For example,
  rwm PathInContainer - Device path within the container PathOnHost - Device
  path on the host Verify that the host device is needed to be accessed from
  within the container and the permissions required are correctly set. If the
  above command returns [], then the container does not have access to host
  devices. This recommendation can be assumed to be compliant."
  tag "fix": "Do not directly expose the host devices to containers. If at all,
  you need to expose the host devices to containers, use the correct set of
  permissions: For example, do not start a container as below: docker run
  --interactive --tty --device=/dev/tty0:/dev/tty0:rwm
  -device=/dev/temp_sda:/dev/temp_sda:rwm centos bash For example, share the
  host device with correct permissions: docker run --interactive --tty
  --device=/dev/tty0:/dev/tty0:rw -device=/dev/temp_sda:/dev/temp_sda:r centos
  bash"
  tag "Default Value": "By default, no host devices are exposed to containers.
  If you do not provide sharing permissions and choose to expose a host device
  to a container, the host device would be exposed with read, write and mknod
  permissions."
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
        its(%w{HostConfig Devices}) { should be_empty }
      end
    end
  end
end

