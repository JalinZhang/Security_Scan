control 'M-4.4' do
  title '4.4 Ensure images are scanned and rebuilt to include security patches (Not Scored)'
  desc  "Images should be scanned frequently for any vulnerabilities. Rebuild
  the images toinclude patches and then instantiate new containers from it.
  Vulnerabilities are loopholes/bugs that can be exploited and security
  patches are updates to resolve these vulnerabilities. We can use image vulnerability scanning
  tools to find any kind of vulnerabilities within the images and then check for available
  patches to mitigate these vulnerabilities. Patches update the system to the most recent code
  base. Being on the current code base is important because that's where vendors focus on fixing
  problems. Evaluate the security patches before applying and follow the patching best
  practices. Also, it would be better if, image vulnerability scanning tools could
  perform binary level analysis or hash based verification instead of just version string matching.
  "
  impact 0.5
  tag "ref": "1.2.3.4.https://docs.docker.com/userguide/dockerimages/
  https://docs.docker.com/docker-cloud/builds/image-scan/ https://blog.docker.com/2016/05/docker-security-scanning/ https://docs.docker.com/engine/reference/builder/#/onbuild"
  tag "severity": 'medium'
  tag "cis_id": '4.4'
  tag "cis_control": ['18.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-2', '4']
  tag "check_text": "Step 1: List all the running instances of containers by
  executing below command: docker ps --quiet Step 2: For each container
  instance, execute the below or equivalent command to find the list of packages
  installed within the container. Ensure that the security updates for
  various affected packages are installed. docker exec $INSTANCE_ID rpm
  -qa Alternatively, you could run image vulnerability scanning tools which can
  scan all the images in your ecosystem and then apply patches for the detected
  vulnerabilities based on your patch management procedures."
  tag "fix": "Follow the below steps to rebuild the images with security
  patches: Step 1: Pull all the base images (i.e., given your set of
  Dockerfiles, extract all images declared in FROM instructions, and re-pull
  them to check for an updated/patched versions). Patch the packages within the
  images too. docker pull Step 2: Force a rebuild of each image: docker build
  --no-cache Step 3: Restart all containers with the updated images. You could
  also use ONBUILD directive in the Dockerfile to trigger particular
  update instructions for images that you know are used as base images
  frequently."
  tag "Default Value": "By default, containers and images are not updated on
  their own."
  ref url: 'https://docs.docker.com/engine/userguide/containers/dockerimages/'
  describe 'A manual review is required to ensure images are scanned and rebuilt to include security patches' do
    skip 'A manual review is required to ensure images are scanned and rebuilt to include security patches'
  end
end

