# CSE222A-project

## AWS Servers information
I chose instane type: `t2.xlarge` with Ubuntu. Its cost is ~0.2$/hour. Three VMs can run for ~3 days, which is easily sufficient to finish the assignment while also providing enough .

I initially wanted to create 3 VMs. Two within the same Availability Zone (like us-west-2), and one in another Availability Zone like us-west-1. However, I ran into issues that I believe have to do with UCSD access (Since I was setting using UCSD account)

| Instance name | Region | Public IPv4 address  | (...?)   | Link to Instance |
|---------------|----------|----------|----------|------------------|
|   1.us-west-2       |   us-west-2  |   34.221.148.182
  |   Row 1  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-0a12e67effb95a521)      |
|   2.us-west-2       |   us-west-2  |   34.222.61.83  |   Row 2  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-07929b2333abd47c0)      |

#### Useful links/commands/info:
* Link to instances: [here](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#Instances:instanceState=running)
* .pem to ssh to instance attached (look access_key.pem)
* Before sshing to an instance, make sure to run `chmod 400 "access_key.pem"`
* To ssh to VM (1): `ssh -i "access_key.pem" ubuntu@ec2-34-222-61-83.us-west-2.compute.amazonaws.com` (might need to change to root@)
* To ssh to VM (2): `ssh -i "access_key.pem" ubuntu@ec2-34-221-148-182.us-west-2.compute.amazonaws.com` (might need to change to root@)