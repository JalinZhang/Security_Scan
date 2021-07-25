# apache-tomcat-8-cis-baseline

InSpec Profile to validate the secure configuration of apache-tomcat-8-cis-baseline, against [CIS'](https://www.cisecurity.org/cis-benchmarks/) Apache Tomcat v8 Benchmark

## Getting Started  
It is intended and recommended that InSpec run this profile from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target remotely over __ssh__.

The latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

## Tailoring to Your Environment
The following inputs must be configured in an inputs ".yml" file for the profile to run correctly for your specific environment. More information about InSpec inputs can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

```yaml
# Description: Tomcat home Directory
tomcat_home: ''

# Description: Tomcat Directory for additional servers
tomcat_base: ''

# Description: Tomcat App Directory
tomcat_app_dir: ''

# Description: Tomcat library Directory
tomcat_lib_dir: ''

# Description: Tomcat service Name
tomcat_service_name: ''

# Description: Tomcat username
tomcat_user: ''

# Description: Port of the tomcat instance
tomcat_port: ''

# Description: Server Info value
tomcat_server_info: ''

# Description: Server Number value
tomcat_server_number: ''

# Description: Server Built value
tomcat_server_built: ''

# Description: Tomcat server configuration file
tomcat_conf_server: ''

# Description: Tomcat web configuration file
tomcat_conf_web: ''

# Description: Group owner of files/directories
tomcat_group: ''

# Description: User owner of files/directories
tomcat_owner: ''

# Description: A list of Realms that should not be enabled
tomcat_realms_list: []

# Description: List of extraneous resources that should not exist
tomcat_extraneous_resource_list: []
```

# Running This Baseline Directly from Github

```
# How to run
inspec exec https://github.com/mitre/apache-tomcat-8-cis-baseline/archive/master.tar.gz -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

### Different Run Options

  [Full exec options](https://docs.chef.io/inspec/cli/#options-3)

## Running This Baseline from a local Archive copy 

If your runner is not always expected to have direct access to GitHub, use the following steps to create an archive bundle of this baseline and all of its dependent tests:

(Git is required to clone the InSpec profile using the instructions below. Git can be downloaded from the [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) site.)

When the __"runner"__ host uses this profile baseline for the first time, follow these steps: 

```
mkdir profiles
cd profiles
git clone https://github.com/mitre/apache-tomcat-8-cis-baseline
inspec archive apache-tomcat-8-cis-baseline
inspec exec <name of generated archive> -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```
For every successive run, follow these steps to always have the latest version of this baseline:

```
cd apache-tomcat-8-cis-baseline
git pull
cd ..
inspec archive apache-tomcat-8-cis-baseline --overwrite
inspec exec <name of generated archive> -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

## Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://heimdall-lite.mitre.org/)__ for a user-interactive, graphical view of the InSpec results. 

The JSON InSpec results file may also be loaded into a __[full heimdall server](https://github.com/mitre/heimdall)__, allowing for additional functionality such as to store and compare multiple profile runs.

## Authors
* Mohamed El-Sharkawi - [HackerShark](https://github.com/HackerShark)
* Craig Chaffee

## Special Thanks 
* Shivani Karikar - [karikarshivani](https://github.com/karikarshivani)

## Contributing and Getting Help
To report a bug or feature request, please open an [issue](https://github.com/mitre/apache-tomcat-8-cis-baseline/issues/new).

### NOTICE

© 2018-2020 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

## NOTICE

MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

## NOTICE  

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.    

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.  

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.  

## NOTICE

CIS Benchmarks are published by the Center for Internet Security (CIS), see: https://www.cisecurity.org/.
