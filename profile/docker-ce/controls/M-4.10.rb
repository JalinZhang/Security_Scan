control 'M-4.10' do
  title '4.10 Ensure secrets are not stored in Dockerfiles (Not Scored)'
  desc  "Do not store any secrets in Dockerfiles.
  Dockerfiles could be backtracked easily by using native Docker commands
  such as docker history and various tools and utilities. Also, as a general practice, image
  publishers provide Dockerfiles to build the credibility for their images. Hence, the
  secrets within these Dockerfiles could be easily exposed and potentially be exploited.
  "
  impact 0.5
  tag "ref": "1. https://github.com/docker/docker/issues/134902.
  http://12factor.net/config3.
  https://avicoder.me/2016/07/22/Twitter-Vine-Source-code-dump/"
  tag "severity": 'medium'
  tag "cis_id": '4.10'
  tag "cis_control": ['14', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "Step 1: Run the below command to get the list of
  images: docker images Step 2: Run the below command for each image in the
  list above, and look for any secrets: docker history
  <Image_ID> Alternatively, if you have access to Dockerfile for the image,
  verify that there are no secrets as described above."
  tag "fix": 'Do not store any kind of secrets within Dockerfiles.'
  tag "Default Value": "By default, there are no restrictions on storing config
  secrets in the Dockerfiles."

  describe 'docker-test' do
    skip 'Manually verify that you have not used secrets in images'
  end
end

