control 'M-4.3' do
  title '4.3 Ensure unnecessary packages are not installed in the container (Not Scored)'
  desc  "Containers tend to be minimal and slim down versions of the Operating
  System. Do not install anything that does not justify the purpose of container.
  Bloating containers with unnecessary software could possibly increase the
  attack surface of the container. This also voids the concept of minimal and slim down
  versions of container images. Hence, do not install anything else apart from what is
  truly needed for the purpose of the container.
  "
  impact 0.5
  tag "ref": "1. https://docs.docker.com/userguide/dockerimages/2.
  http://www.livewyer.com/blog/2015/02/24/slimming-down-your-dockercontainers-alpine-linux3.
  https://github.com/progrium/busybox"
  tag "severity": 'medium'
  tag "cis_id": '4.3'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "Step 1: List all the running instances of containers by
  executing below command: docker ps --quiet Step 2: For each container
  instance, execute the below or equivalent command: docker exec $INSTANCE_ID
  rpm -qa The above command would list the packages installed on the container.
  Review the list and ensure that it is legitimate."
  tag "fix": "At the outset, do not install anything on the container that does
  not justify the purpose. If the image had some packages that your container
  does not use, uninstall them. Consider using a minimal base image rather than
  the standard Redhat/Centos/Debian images if you can. Some of the options
  include BusyBox and Alpine. Not only does this trim your image size from
  >150Mb to ~20 Mb, there are also fewer tools and paths to escalate privileges.
  You can even remove the package installer as a final hardening measure for
  leaf/production containers."
  tag "Default Value": 'Not Applicable.'
  ref url: 'https://docs.docker.com/engine/userguide/containers/dockerimages/'
  ref url: 'http://www.livewyer.com/blog/2015/02/24/slimming-down-your-docker-containers-alpine-linux'
  ref url: 'https://github.com/progrium/busybox'
  describe 'A manual review is required to ensure unnecessary packages are not installed in the container' do
    skip 'A manual review is required to ensure unnecessary packages are not installed in the container'
  end
end

