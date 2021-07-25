control 'M-2.5' do
  title '2.5 Ensure aufs storage driver is not used (Scored)'
  desc  "Do not use aufs as storage driver for your Docker instance.
  The aufs storage driver is the oldest storage driver. It is based on a
  Linux kernel patch-set that is unlikely to be merged into the main Linux kernel. aufs driver is
  also known to cause some serious kernel crashes. aufs just has legacy support from Docker. Most
  importantly, aufs is not a supported driver in many Linux distributions using latest Linux kernels.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.5'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Execute the below command and verify that aufs is not used as
  storage driver: docker info | grep -e \"^Storage Driver:\\s*aufs\\s*$\" The
  above command should not return anything."
  tag "fix": "Do not explicitly use aufs as storage driver. For example, do
  not start Docker daemon as below: dockerd --storage-driver aufs"
  tag "Default Value": "By default, Docker uses devicemapper as the storage
  driver on most of the platforms. Default storage driver can vary based on your
  OS vendor. You should use the storage driver that is best supported by your
  preferred vendor."
  ref 'supported-backing-filesystems', url: 'https://docs.docker.com/engine/userguide/storagedriver/selectadriver/#supported-backing-filesystems'
  ref 'storagedriver', url: 'https://docs.docker.com/engine/userguide/storagedriver/'
  ref 'Docker daemon storage driver options', url: 'https://docs.docker.com/engine/reference/commandline/cli/#daemon-storage-driver-option'
  ref 'permission denied if chown after chmod', url: 'https://github.com/docker/docker/issues/6047'
  ref 'Switch from aufs to devicemapper', url: 'http://muehe.org/posts/switching-docker-from-aufs-to-devicemapper/'
  ref 'Deep dive into docker storage drivers', url: 'http://jpetazzo.github.io/assets/2015-03-05-deep-dive-into-docker-storage-drivers.html#1'

  describe json('/etc/docker/daemon.json') do
    its(['storage-driver']) { should_not eq('aufs') }
  end
end

