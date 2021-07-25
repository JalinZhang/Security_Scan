control "M-7.7" do
  title "7.7 Configure log file size limit (Scored)"
  desc  "By default, the logging.properties file will have no defined limit for
the log file size. This is a potential denial of service attack as it would be
possible to fill a drive or partition containing the log files. Establishing a
maximum log size that is smaller than the partition size will help mitigate the
risk of an attacker maliciously exhausting disk space. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.7"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Validate the max file limit is not greater than the size
of the partition where the log files are
stored.
"
  tag "fix": "Create the following entry in your logging.properties file. This
field is specified in bytes.
java.util.logging.FileHandler.limit=10000
"
  tag "Default Value": "No limit by default.\n\n"
end
