control 'M-1.1' do
  title "1.1 Ensure a separate partition for containers has been created
  (Scored)"
  desc "All Docker containers and their data and metadata is stored under
  /var/lib/docker
  directory. By default, /var/lib/docker would be mounted under / or /var
  partitions based
  on availability.
  Docker depends on /var/lib/docker as the default directory where all Docker
  related files,
  including the images, are stored. This directory might fill up fast and
  soon Docker and the
  host could become unusable. So, it is advisable to create a separate
  partition (logical
  volume) for storing Docker files.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.1'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['AC-6', '4']
  tag "check_text": "At the Docker host execute the below command: grep
  /var/lib/docker /etc/fstab This should return the partition details for
  /var/lib/docker mount point."
  tag "fix": "For new installations, create a separate partition for
  /var/lib/docker mount point. For systems that were previously installed, use
  the Logical Volume Manager (LVM) to create partitions."
  tag "Default Value": "By default, /var/lib/docker would be mounted under / or
  /var partitions based on availability."
  ref 'Docker storage recommendation', url: 'http://www.projectatomic.io/docs/docker-storage-recommendation/'

  describe mount('/var/lib/docker') do
    it { should be_mounted }
  end
end

