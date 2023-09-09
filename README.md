# AWS Cloudformation Mini Project
A mini project to learn about AWS Cloudformation. Launch a VPC and an EC2 instance.

## Additional Resources
1. [**AWS CloudFormation Documentation**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
2. [**AWS CloudFormation Template reference**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html**)
3. [**AWS CLI Cloudformation Reference**](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/)
4. [**Medium Blog- By Josh Hargett](https://awstip.com/week-10-11-aws-cloud-bootcamp-558de5b3fed7)

## Terminologies

## Text Editors
1. [**VSCode**](https://code.visualstudio.com/)
2. [**AWS Cloud9**](https://aws.amazon.com/pm/cloud9/?trk=dcd0f000-1e1c-4a73-9f3a-f86bb6d7d1ee&sc_channel=ps&ef_id=CjwKCAjwjOunBhB4EiwA94JWsOXx1UYRpVKNvwB1IVv29PLwBmtEM-nCiLUVYT_26uAJjctYUjQ_FRoCNCQQAvD_BwE:G:s&s_kwcid=AL!4422!3!651612761006!e!!g!!aws%20cloud9!19828231353!150095226914)

## Plan
1. Create vpc
2. Create Internet Gateway
3. Create Custom Route Table
4. Create a Subnet
5. Associate subnet with Route Table
6. Create a network interface with an ip in the subnet that was created in step 4
7. Assign an elastic IP to the network interface created in step 6
8. Create Ubuntu server (EC2 instance) and install/enable apache2

## Setting up your environment
### CloudFormation Command Line Interface (CFN-CLI) and Prerequisites
- [**What is the CloudFormation Command Line Interface (CFN-CLI)?**](https://docs.aws.amazon.com/cloudformation-cli/latest/userguide/what-is-cloudformation-cli.html)

#### Install
To install the CFN-CLI run the command below

```sh
pip install cloudformation-cli cloudformation-cli-java-plugin cloudformation-cli-go-plugin cloudformation-cli-python-plugin cloudformation-cli-typescript-plugin
```
For a specific OS follow the instructions [**here**](https://docs.aws.amazon.com/cloudformation-cli/latest/userguide/what-is-cloudformation-cli.html)

### CFN-Toml
Toml Configuration for Bash scripts using CloudFormation created by [**Andrew Brown**](https://github.com/omenking) written in Ruby.
This will allow us to pull in external parameters as variables within our deploy scripts, then pass them during creation from our CFN templates. These values are normally hardcoded into the script/command to deploy the CFN template, but with Andrew's library this won't be necessary.

Go to Andrew's public repo for cfn-toml here: https://github.com/teacherseat/cfn-toml/tree/main and we walk through how to use it. We begin by installing cfn-toml through the CLI:

```sh
gem install cfn-toml
```

Extracting environment variables and parsing parameter configurations using [TOML](https://www.w3schools.io/file/toml-introduction/) for cloudformation templates.

See the configs for [**Newtork**]() and [**EC2**]() using toml.


## AWS CloudFormation Networking
- VPC
- IGW
- Route Tables
- Subnets
  - SubnetPub1
- Security Group
    - HTTP 80
    - HTTPS 443
    - SSH 22

## EC2 Instance (Ubuntu Server)
