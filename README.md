# AWS Cloudformation Mini Project
A mini project to learn about AWS Cloudformation. Launch a VPC and an EC2 instance.

## Additional Resources
1. [**AWS CloudFormation Documentation**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
2. [**AWS CloudFormation Template reference**](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html**)
3. [**AWS CLI Cloudformation Reference - V2**](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/index.html)
4. [**Medium Blog- By Josh Hargett**](https://awstip.com/week-10-11-aws-cloud-bootcamp-558de5b3fed7)

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

### Folder structure

```
├── cloudformation-practice
│   ├── aws
│   │   └── cfn
│   │       ├── ec2
│   │       │   ├── config.toml
│   │       │   └── template.yaml
│   │       └── network
│   │           ├── config.toml
│   │           └── template.yaml
│   └── bin
│       └── cfn
│           ├── ec2-deploy
│           └── network-deploy
```

The directories in `aws/cfn` contain the cloudformation templates and configurations for the network and ec2 instance to be provisioned

The directory `bin/cfn` contains bash scripts to automate the deployment and cleanup of the network and ec2 templates.


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
  
![VPC EC2](images/vpc_ec2.drawio.png)

1. **Create vpc**

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: "EC2 Instance with Ubuntu Server and Apache"

Parameters:
  VpcCidrBlock:
    Type: String
    Default: 10.0.0.0/16
  SubnetCidrBlocks:
    Description: "Comma-delimited list of CIDR blocks for our private public subnets"
    Type: CommaDelimitedList
    Default: >
      10.0.0.0/24, 
      10.0.4.0/24
  Az1:
    Type: AWS::EC2::AvailabilityZone::Name
    Default: us-east-1a

Resources:
  VPC:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidrBlock
      EnableDnsHostnames: true
      EnableDnsSupport: true
      InstanceTenancy: default
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}VPC"
```

The provided AWS CloudFormation template snippet defines an AWS CloudFormation stack template using the AWS CloudFormation Template Version "2010-09-09". This template is used to create AWS resources for setting up an EC2 instance running Ubuntu Server with Apache installed. Let's break down the different sections of this CloudFormation template:

- **AWSTemplateFormatVersion**:
   - This section specifies the version of the CloudFormation template format being used. In this case, it's "2010-09-09," which is a commonly used version.

- **Description**:
   - A human-readable description of the CloudFormation stack/template. In this case, it describes the purpose of the template, which is to create an EC2 instance with Ubuntu Server and Apache.

- **Parameters**:
   - This section defines input parameters that allow users to customize the behavior of the CloudFormation stack when it's created. These parameters can be provided when the stack is created or updated.
   - **VpcCidrBlock**: A parameter named `VpcCidrBlock` of type String, which is used to specify the CIDR block for the Virtual Private Cloud (VPC). The default value is "10.0.0.0/16".
   - **SubnetCidrBlocks**: A parameter named `SubnetCidrBlocks` of type CommaDelimitedList. It allows users to provide a comma-delimited list of CIDR blocks for creating private and public subnets within the VPC. The default value is a list containing two CIDR blocks, "10.0.0.0/24" and "10.0.4.0/24".
   - **Az1**: A parameter named `Az1` of type AWS::EC2::AvailabilityZone::Name. It allows users to specify an availability zone. The default value is "us-east-1a".

- **Resources**:
   - This section defines the AWS resources that will be created and managed by this CloudFormation stack.
   - **VPC**: An AWS resource of type `AWS::EC2::VPC`. This resource represents the creation of a Virtual Private Cloud (VPC).
     - **CidrBlock**: The CIDR block for the VPC is specified using the `!Ref` function, which refers to the `VpcCidrBlock` parameter. It uses the value provided for `VpcCidrBlock` when the stack is created or updated.
     - **EnableDnsHostnames** and **EnableDnsSupport**: These properties are set to true, enabling DNS hostnames and DNS resolution within the VPC.
     - **InstanceTenancy**: The tenancy of the instances launched in the VPC is set to "default," meaning they will run on shared hardware by default.
     - **Tags**: Tags are key-value pairs associated with the VPC. In this case, a tag with the key "Name" and a value generated using `!Sub` function, which substitutes `${AWS::StackName}VPC`, is attached to the VPC.

This template snippet primarily focuses on creating a VPC with customizable parameters, such as the VPC CIDR block and availability zone. Additional resources and configurations for launching an EC2 instance with Apache can be added in subsequent sections of the complete CloudFormation template, which are not included in the provided snippet.

2. **Create Internet Gateway**

```yaml
IGW:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internetgateway.html
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}IGW"
  AttachIGW:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref IGW
```

The provided code snippet is an extension of the previous AWS CloudFormation template and defines two additional AWS resources: an Internet Gateway (IGW) and the attachment of the Internet Gateway to the Virtual Private Cloud (VPC). Let's break down this part of the template:

- **IGW**:
   - This section defines an AWS resource named `IGW`, which represents an Internet Gateway.
   - **Type**: Specifies the resource type as `AWS::EC2::InternetGateway`.
   - **Properties**:
     - **Tags**: This property is used to attach tags to the Internet Gateway. In this case, a single tag is defined with the key "Name" and a value generated using the `!Sub` function, which substitutes `${AWS::StackName}IGW`. This tag provides a human-readable name to the Internet Gateway.

- **AttachIGW**:
   - This section defines an AWS resource named `AttachIGW`, which represents the attachment of the Internet Gateway to the VPC.
   - **Type**: Specifies the resource type as `AWS::EC2::VPCGatewayAttachment`.
   - **Properties**:
     - **VpcId**: The `!Ref` function is used to reference the `VPC` resource defined earlier in the template. This property specifies the VPC to which the Internet Gateway will be attached.
     - **InternetGatewayId**: The `!Ref` function is used to reference the `IGW` resource defined earlier in the template. This property specifies the Internet Gateway that will be attached to the VPC.

In summary, this part of the template creates an Internet Gateway (IGW) and attaches it to the VPC created earlier. The attachment allows resources within the VPC to communicate with the internet. The IGW is tagged with a name for easy identification. This step is typically required when setting up a VPC for public internet access, which is often necessary for hosting web servers, load balancers, or other services that require internet connectivity.

3. **Create Custom Route Table**

```yaml
RouteTable:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-routetable.html
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}RT"
  RouteToIGW:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html
    Type: AWS::EC2::Route
    DependsOn: AttachIGW
    Properties:
      RouteTableId: !Ref RouteTable
      GatewayId: !Ref IGW
      DestinationCidrBlock: 0.0.0.0/0
```

This portion of the AWS CloudFormation template continues to configure networking components within the Virtual Private Cloud (VPC) created earlier. It defines a Route Table and a default route to the Internet Gateway (IGW). Let's break down this section:

- **RouteTable**:
   - This section defines an AWS resource named `RouteTable`, which represents a route table in the VPC.
   - **Type**: Specifies the resource type as `AWS::EC2::RouteTable`.
   - **Properties**:
     - **VpcId**: The `!Ref` function is used to reference the `VPC` resource defined earlier in the template. This property specifies the VPC to which the route table belongs.
     - **Tags**: A tag with the key "Name" and a value generated using the `!Sub` function, `${AWS::StackName}RT`, is attached to the route table. This tag provides a human-readable name to the route table.

- **RouteToIGW**:
   - This section defines an AWS resource named `RouteToIGW`, which represents a route in the route table that directs traffic to the Internet Gateway (IGW).
   - **Type**: Specifies the resource type as `AWS::EC2::Route`.
   - **DependsOn**: This property specifies a dependency on the `AttachIGW` resource, ensuring that the Internet Gateway is attached to the VPC before creating this route.
   - **Properties**:
     - **RouteTableId**: The `!Ref` function is used to reference the `RouteTable` resource defined earlier in the template. This property specifies the route table to which the route will be added.
     - **GatewayId**: The `!Ref` function is used to reference the `IGW` resource defined earlier in the template. This property specifies the Internet Gateway to which the route directs traffic.
     - **DestinationCidrBlock**: This property specifies the destination CIDR block for the route. In this case, it's set to "0.0.0.0/0," which is a default route for all internet-bound traffic. Any traffic with an unknown destination will be sent to the Internet Gateway, allowing instances in the VPC to access the internet.

In summary, this part of the template creates a route table for the VPC and adds a default route that directs all internet-bound traffic to the Internet Gateway. This configuration is essential for enabling internet connectivity to resources within the VPC, making it possible for instances in the VPC to communicate with external services and the internet.

4. **Create a Subnet**

```yaml
SubnetPub1:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html
    Type: AWS::EC2::Subnet
    Properties:
      AvailabilityZone: !Ref Az1
      CidrBlock: !Select [0, !Ref SubnetCidrBlocks]
      EnableDns64: false
      MapPublicIpOnLaunch: true #public subnet
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}SubnetPub1"
```

This section of the AWS CloudFormation template defines a public subnet within the Virtual Private Cloud (VPC) created earlier. Let's break down this part of the template:

- **SubnetPub1**:
   - This section defines an AWS resource named `SubnetPub1`, which represents a subnet within the VPC.
   - **Type**: Specifies the resource type as `AWS::EC2::Subnet`.
   - **Properties**:
     - **AvailabilityZone**: The `!Ref` function is used to reference the `Az1` parameter defined earlier in the template. This property specifies the availability zone in which the subnet will be created.
     - **CidrBlock**: The `!Select` and `!Ref` functions are used together to select the first CIDR block from the `SubnetCidrBlocks` parameter, which is a comma-delimited list of CIDR blocks provided by the user when the stack is created. This property specifies the CIDR block for the subnet.
     - **EnableDns64**: This property is set to `false`, indicating that DNS64 is not enabled for this subnet. DNS64 is used for IPv6 compatibility.
     - **MapPublicIpOnLaunch**: This property is set to `true`, indicating that instances launched in this subnet will be automatically assigned a public IP address upon launch. This is a characteristic of public subnets, which allow instances to communicate with the internet.
     - **VpcId**: The `!Ref` function is used to reference the `VPC` resource defined earlier in the template. This property specifies the VPC to which the subnet belongs.
     - **Tags**: A tag with the key "Name" and a value generated using the `!Sub` function, `${AWS::StackName}SubnetPub1`, is attached to the subnet. This tag provides a human-readable name to the subnet.

In summary, this part of the template creates a public subnet (`SubnetPub1`) within the VPC. It specifies the availability zone, CIDR block, and other properties necessary for the subnet to be considered public. Instances launched in this subnet will have public IP addresses by default, allowing them to communicate with the internet.

6. **Associate subnet with Route Table**

```yaml
SubnetPub1RTAssociation:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnetroutetableassociation.html
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref SubnetPub1
      RouteTableId: !Ref RouteTable
```

This section of the AWS CloudFormation template defines a resource named `SubnetPub1RTAssociation`, which represents the association of a subnet (`SubnetPub1`) with a route table (`RouteTable`). Let's break down this part of the template:

- **SubnetPub1RTAssociation**:
   - This section defines an AWS resource named `SubnetPub1RTAssociation`, which represents the association of a subnet with a route table.
   - **Type**: Specifies the resource type as `AWS::EC2::SubnetRouteTableAssociation`.

   - **Properties**:
     - **SubnetId**: The `!Ref` function is used to reference the `SubnetPub1` resource defined earlier in the template. This property specifies the subnet to be associated with the route table.

     - **RouteTableId**: The `!Ref` function is used to reference the `RouteTable` resource defined earlier in the template. This property specifies the route table with which the subnet will be associated.

This association ensures that the subnet (`SubnetPub1`) uses the specified route table (`RouteTable`) for routing traffic. In the context of a public subnet, this association typically means that the subnet will use the route table with a default route pointing to the Internet Gateway. This configuration allows instances in the public subnet to route internet-bound traffic through the Internet Gateway.

In summary, this part of the template associates the public subnet (`SubnetPub1`) with the route table (`RouteTable`), enabling the subnet to use the appropriate routing configuration for internet connectivity.

6. **Create Security Group**

```yaml
SecurityGroup:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupName: "allow_web_traffic"
      GroupDescription: "Allow web inbound traffic"
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - CidrIp: "0.0.0.0/0"
          IpProtocol: "tcp"
          FromPort: 443
          ToPort: 443
        - CidrIp: "0.0.0.0/0"
          IpProtocol: "tcp"
          FromPort: 80
          ToPort: 80
        - CidrIp: "0.0.0.0/0"
          IpProtocol: "tcp"
          FromPort: 22
          ToPort: 22
      SecurityGroupEgress:
        - CidrIp: "0.0.0.0/0"
          IpProtocol: "-1"
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}SG"
```

This section of the AWS CloudFormation template defines an AWS Security Group resource (`SecurityGroup`) for controlling inbound and outbound traffic to and from instances within the Virtual Private Cloud (VPC). Let's break down this part of the template:

- **SecurityGroup**:
   - This section defines an AWS resource named `SecurityGroup`, which represents an EC2 Security Group.
   - **Type**: Specifies the resource type as `AWS::EC2::SecurityGroup`.

   - **Properties**:
     - **GroupName**: Specifies the name of the security group as "allow_web_traffic".
     - **GroupDescription**: Provides a description for the security group as "Allow web inbound traffic".
     - **VpcId**: The `!Ref` function is used to reference the `VPC` resource defined earlier in the template. This property specifies the VPC to which the security group belongs.

     - **SecurityGroupIngress**: This property defines the inbound rules for allowing incoming traffic to instances associated with this security group.
       - Three inbound rules are defined:
         - Allow inbound traffic on TCP port 443 (HTTPS) from any source IP address ("0.0.0.0/0").
         - Allow inbound traffic on TCP port 80 (HTTP) from any source IP address ("0.0.0.0/0").
         - Allow inbound traffic on TCP port 22 (SSH) from any source IP address ("0.0.0.0/0").

     - **SecurityGroupEgress**: This property defines the outbound rules for allowing outgoing traffic from instances associated with this security group.
       - One outbound rule is defined, allowing all outbound traffic to any destination IP address ("0.0.0.0/0").

     - **Tags**: A tag with the key "Name" and a value generated using the `!Sub` function, `${AWS::StackName}SG`, is attached to the security group. This tag provides a human-readable name to the security group.

This security group is configured to allow incoming traffic on common web ports (HTTP, HTTPS) and SSH for administrative access. The outbound rule allows all outbound traffic, which is a permissive configuration.

In practice, this security group can be associated with EC2 instances to control their inbound and outbound network traffic according to the defined rules. For example, if you associate this security group with a web server instance, it will be able to accept HTTP, HTTPS, and SSH traffic from any source, and it can send traffic to any destination.

### Outputs

```yaml
Outputs:
  VpcId:
    Value: !Ref VPC
    Export:
      Name: !Sub "${AWS::StackName}VpcId"
  VpcCidrBlock:
    Value: !GetAtt VPC.CidrBlock
    Export:
      Name: !Sub "${AWS::StackName}VpcCidrBlock"
  SubnetCidrBlocks:
    Value: !Join [",", !Ref SubnetCidrBlocks]
    Export:
      Name: !Sub "${AWS::StackName}SubnetCidrBlocks"
  PublicSubnetIds:
    Value: !Join
      - ","
      - - !Ref SubnetPub1
    Export:
      Name: !Sub "${AWS::StackName}PublicSubnetIds"
  AvailabilityZones:
    Value: !Join
      - ","
      - - !Ref Az1
    Export:
      Name: !Sub "${AWS::StackName}AvailabilityZones"
  SecurityGroupId:
    Value: !GetAtt SecurityGroup.GroupId
    Export:
      Name: !Sub "${AWS::StackName}SecurityGroupId"
```

The "Outputs" section of the AWS CloudFormation template defines various outputs that provide information about the resources created within the stack. These outputs can be useful for referencing resource information in other stacks or for external use. Let's break down each of the defined outputs:

1. **VpcId**:
   - This output is named "VpcId."
   - It uses the `!Ref` function to get the ID of the VPC resource created earlier in the template.
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}VpcId`. This allows other stacks to import and use this VPC ID.

2. **VpcCidrBlock**:
   - This output is named "VpcCidrBlock."
   - It uses the `!GetAtt` function to get the CIDR block of the VPC resource (`VPC.CidrBlock`).
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}VpcCidrBlock`. This allows other stacks to import and use this VPC CIDR block.

3. **SubnetCidrBlocks**:
   - This output is named "SubnetCidrBlocks."
   - It uses the `!Ref` function to reference the `SubnetCidrBlocks` parameter, which is a comma-delimited list of CIDR blocks for subnets.
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}SubnetCidrBlocks`. This allows other stacks to import and use these subnet CIDR blocks as a comma-delimited list.

4. **PublicSubnetIds**:
   - This output is named "PublicSubnetIds."
   - It uses the `!Ref` function to reference the `SubnetPub1` resource, representing the public subnet.
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}PublicSubnetIds`. This allows other stacks to import and use the ID of the public subnet.

5. **AvailabilityZones**:
   - This output is named "AvailabilityZones."
   - It uses the `!Ref` function to reference the `Az1` parameter, which represents the availability zone.
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}AvailabilityZones`. This allows other stacks to import and use the availability zone.

6. **SecurityGroupId**:
   - This output is named "SecurityGroupId."
   - It uses the `!GetAtt` function to get the ID of the `SecurityGroup` resource created earlier in the template.
   - The `Export` section specifies that this output should be exported with a name generated using the `!Sub` function, `${AWS::StackName}SecurityGroupId`. This allows other stacks to import and use the ID of the security group.

These outputs make it convenient to reference and use essential information about the resources created in this CloudFormation stack in other stacks or for external purposes, such as configuring other AWS resources or services.

## EC2 Instance (Ubuntu Server)
