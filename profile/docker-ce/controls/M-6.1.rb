control 'M-6.1' do
  title '6.1 Ensure image sprawl is avoided (Not Scored)'
  desc  "Do not keep a large number of container images on the same host. Use only
  tagged images as appropriate. Tagged images are useful to fall back from \"latest\" to a specific
  version of an image in production. Images with unused or old tags may contain vulnerabilities that
  might be exploited, if instantiated. Additionally, if you fail to remove unused
  images from the system and there are various such redundant and unused images, the host filesystem
  may become full, which could lead to denial of service.
  "
  impact 0.5
  tag "ref": "1.
  http://craiccomputing.blogspot.in/2014/09/clean-up-unused-docker-containersand.html2.
  https://forums.docker.com/t/command-to-remove-all-unused-images/20/83.
  https://github.com/docker/docker/issues/90544.
  https://docs.docker.com/engine/reference/commandline/rmi/5.
  https://docs.docker.com/engine/reference/commandline/pull/6.
  https://github.com/docker/docker/pull/11109"
  tag "severity": 'medium'
  tag "cis_id": '6.1'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Step 1 Make a list of all image IDs that are currently
  instantiated by executing below command: docker images --quiet | xargs docker
  inspect --format '{{ .Id }}: Image={{.Config.Image }}' Step 2: List all the
  images present on the system by executing below command: docker images Step
  3: Compare the list of image IDs populated from Step 1 and Step 2 and find out
  which images are currently not being instantiated. If any such unused or old
  images are found, discuss with the system administrator the need to keep such
  images on the system. If such a need is not justified enough, then this
  recommendation is non-compliant."
  tag "fix": "Keep the set of the images that you actually need and establish a
  workflow to remove old or stale images from the host. Additionally, use
  features such as pull-by-digest to get specific images from the
  registry. Additionally, you can follow the below set of steps to find out unused
  images on the system and delete them. Step 1 Make a list of all image IDs
  that are currently instantiated by executing the below command: docker images
  --quiet | xargs docker inspect --format '{{ .Id }}: Image={{.Config.Image
  }}' Step 2: List all the images present on the system by executing below
  command: docker images Step 3: Compare the list of image IDs populated from
  Step 1 and Step 2 and find out which images are currently not being
  instantiated. Step 4: Decide if you want to keep the images that are not
  currently in use. If not delete them by executing the below command: docker rmi
  $IMAGE_ID"
  tag "Default Value": "Images and layered filesystems remain accessible on the
  host until the administrator removes all tags that refer to those images or layers."
  ref 'http://craiccomputing.blogspot.de/2014/09/clean-up-unused-docker-containers-and.html'
  ref 'https://forums.docker.com/t/command-to-remove-all-unused-images/20/7'
  ref 'https://github.com/docker/docker/issues/9054'
  ref 'https://docs.docker.com/engine/reference/commandline/cli/#rmi'
  ref 'https://docs.docker.com/engine/reference/commandline/cli/#pull'
  ref 'https://github.com/docker/docker/pull/11109'

  instantiated_images = command('docker ps -qa | xargs docker inspect -f \'{{.Image}}\'').stdout.split
  all_images = command('docker images -q --no-trunc').stdout.split
  diff = all_images - instantiated_images

  describe diff do
    it { should be_empty }
  end
end

