# CSE222A-project

## AWS Servers information
I chose instane type: `t2.xlarge` with Ubuntu. Its cost is ~0.2$/hour. Three VMs can run for ~3 days, which is easily sufficient to finish the assignment while also providing wayyyy too much compute.

I initially wanted to create 3 VMs. Two within the same Availability Zone (like us-west-2), and one in another Availability Zone like us-west-1. However, I ran into issues when spinning up EC2 in any other region than us-west-2. I believe the issue had to do with UCSD AWS permission set up (Since I was setting using UCSD account)

| Instance name | Region | Public IPv4 address  | Server/Client?   | Link to Instance |
|---------------|----------|----------|----------|------------------|
|   1.us-west-2       |   us-west-2  |   34.221.148.182|   Server  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-0a12e67effb95a521)      |
|   2.us-west-2       |   us-west-2  |   34.222.61.83  |   Client  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-07929b2333abd47c0)      |

#### Useful links/commands/info AWS related:
* Link to instances: [here](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#Instances:instanceState=running)
* When setting up instances I allowed all traffic to come through (via the AWS console) (I'm aware it's a bad practice. Just a temp change)
* .pem to ssh to instance attached (look access_key.pem)
* Before sshing to an instance, make sure to run `chmod 400 "access_key.pem"`
* To ssh to VM (1) (server): `ssh -i "access_key.pem" ubuntu@ec2-34-222-61-83.us-west-2.compute.amazonaws.com` (might need to change to root@)
* To ssh to VM (2) (client): `ssh -i "access_key.pem" ubuntu@ec2-34-221-148-182.us-west-2.compute.amazonaws.com` (might need to change to root@)


## Shell commands used in the assignment

#### General for moving around VMs:
* `sudo pkill iperf3` - to kill any uncessary iperf3 sesssions that would persist
* `vim` & `less` to ad-hoc investigate the contents of networking files
* `scp -i "access_key.pem" ubuntu@ec2-34-221-148-182.us-west-2.compute.amazonaws.com:/home/ubuntu/test.json .` - to download files later used for data analysis from 2nd VM (client)

#### General for network setup:
* `tc qdisc add dev eth0 root netem delay 20ms` to introduce a 20 sec delay, as per stack overflow: [here](https://serverfault.com/questions/787006/how-to-add-latency-and-bandwidth-limit-interface-using-tc)
* `sysctl net.ipv4.tcp_congestion_control` - to check which congestion control is utilized in the current session
* `sudo sysctl -w net.ipv4.tcp_congestion_control=bbr` - to overwrite (temporarily) the networking protocol to be bbr
* `sudo sysctl -w net.ipv4.tcp_congestion_control=cubic` - to overwrite (temporarily) the networking protocol to be cubic

#### Large file transfer (using iperf):
* To set up server and listen for message on 1st VM: `iperf3 -s` (`-s` stands for server)
* To set up client (and send message to 1st VM from 2nv VM): `iperf3 -c 34.221.148.182 -t 360 --json > (*).json` (eg. run iperf3 to send files to VM 1 for ~360 seconds, saving data as json into .json file)


#### Large file transfer (using iperf):