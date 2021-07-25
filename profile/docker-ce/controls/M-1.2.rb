control 'M-1.2' do
  title '1.2 Ensure the container host has been Hardened (Not Scored)'
  desc  "
  Containers run on a Linux host. A container host can run one or more
  containers. It is of utmost importance to harden the host to mitigate host security misconfiguration.
  You should follow infrastructure security best practices and harden your host OS. Keeping
  the host system hardened would ensure that the host vulnerabilities are
  mitigated. Not hardening the host system could lead to security exposures and breaches.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '1.2'
  tag "cis_control": ['3', '6.1']
  tag "cis_level": 'Level 1 - Linux Host OS'
  tag "nist": ['CM-6', '4']
  tag "check_text": "Ensure that the host specific security guidelines are followed.
  Ask the system administrators which security benchmark the current host
  system complies with. Ensure that the host systems actually complies with that
  host specific security benchmark."
  tag "fix": "You may consider various CIS Security Benchmarks for your
  container host. If you have other security guidelines or regulatory
  requirements to adhere to, please follow them as suitable in your
  environment. Additionally, you can run a kernel with grsecurity and PaX. This
  would add many safety checks, both at compile-time and run-time. It is also
  designed to defeat many exploits and has powerful security features. These
  features do not require Docker-specific configuration, since those security
  features apply system-wide, independent of containers."
  tag "Default Value": "By default, host has factory settings. It is not
  hardened."
  ref 'Hardening Framework dev-sec.io', url: 'http://dev-sec.io'
  ref 'Docker security article', url: 'https://docs.docker.com/engine/security/security/'
  ref 'CIS Benchmarks', url: 'https://benchmarks.cisecurity.org/downloads/multiform/index.cfm'
  ref 'security', url: 'https://docs.docker.com/engine/security/security/'
  ref 'benchmarks', url: 'https://learn.cisecurity.org/benchmarks'
  ref 'other-kernel-security-features', url: 'https://docs.docker.com/engine/security/security/#other-kernel-security-features'
  ref 'grsecurity', url: 'https://grsecurity.net/'
  ref 'grsecurity Wiki', url: 'https://en.wikibooks.org/wiki/Grsecurity'
  ref 'Homepage of The PaX Team', url: 'https://pax.grsecurity.net/'
  ref 'PAX Wiki', url: 'http://en.wikipedia.org/wiki/PaX'
  describe 'A manual review is required to ensure the container host has been hardened' do
    skip 'A manual review is required to ensure the container host has been hardened'
  end
end

