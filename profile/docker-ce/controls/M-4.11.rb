control 'M-4.11' do
  title '4.11 Ensure verified packages are only Installed (Not Scored)'
  desc  "Verify authenticity of the packages before installing them in the image.
  Verifying authenticity of the packages is essential for building a secure
  container image. Tampered packages could potentially be malicious or have some known
  vulnerabilities that could be exploited.
  "
  impact 0.5
  tag "ref": "1.
  http://www.oreilly.com/webops-perf/free/files/docker-security.pdf2.
  https://github.com/dockerlibrary/httpd/blob/12bf8c8883340c98b3988a7bade8ef2d0d6dcf8a/2.4/Dockerfile3.
  https://github.com/dockerlibrary/php/blob/d8a4ccf4d620ec866d5b42335b699742df08c5f0/7.0/alpine/Dockerfile4.
  https://access.redhat.com/security/team/key"
  tag "severity": 'medium'
  tag "cis_id": '4.11'
  tag "cis_control": ['18.1', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-2', '4']
  tag "check_text": "Step 1: Run the below command to get the list of
  images: docker images Step 2: Run the below command for each image in the
  list above, and look for how the authenticity of the packages is determined.
  This could be via the use of GPG keys or other secure package distribution
  mechanisms docker history <Image_ID> Alternatively, if you have access to
  Dockerfile for the image, verify that the authenticity of the packages is
  checked."
  tag "fix": "Use GPG keys for downloading and verifying packages or any other
  secure package distribution mechanism of your choice."
  tag "Default Value": 'Not Applicable'
  describe 'A manual review is required to ensure verified packages are only installed' do
    skip 'A manual review is required to ensure verified packages are only installed'
  end
end

