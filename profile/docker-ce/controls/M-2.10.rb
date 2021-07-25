control 'M-2.10' do
  title '2.10 Ensure base device size is not changed until needed (Scored)'
  desc  "In certain circumstances, you might need containers bigger than 10G in
  size. In these cases, carefully choose the base device size.
  The base device size can be increased at daemon restart. Increasing the
  base device size allows all future images and containers to be of the new base device size.
  A user can use this option to expand the base device size however shrinking is not
  permitted. This value affects the system-wide base empty filesystem that may already be
  initialized and inherited by pulled images.
  Though the file system does not allot the increased size if it is empty, it
  will use more space for the empty case depending upon the device size. This may cause a denial
  of service by ending up in file system being over-allocated or full.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.10'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "ps -ef | grep dockerd Execute the above command and it should
  not show any --storage-opt dm.basesize parameters."
  tag "fix": "Do not set --storage-opt dm.basesize until needed.\n"
  tag "Default Value": "The default base device size is 10G.\n"
  ref 'Docker daemon storage driver options', url: 'https://docs.docker.com/engine/reference/commandline/daemon/#storage-driver-options'
  ref 'storagedriver-options', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#storagedriver-options'

  describe json('/etc/docker/daemon.json') do
    its(['storage-opts']) { should eq(['dm.basesize=10G']) }
  end
end

