# CSE222A-project

## AWS Servers information
I chose instane type: `t2.xlarge` with Ubuntu. Its cost is ~0.2$/hour. Three VMs can run for ~3 days, which is easily sufficient to finish the assignment while also providing wayyyy too much compute.

I initially wanted to create 3 VMs. Two within the same Availability Zone (like us-west-2), and one in another Availability Zone like us-west-1. However, I ran into issues when spinning up EC2 in any other region than us-west-2. I believe the issue had to do with UCSD AWS permission set up (Since I was setting using UCSD account)

| Instance name | Region | Public IPv4 address (these are dynamic and change on each VM turn off)  | Server/Client?   | Link to Instance |
|---------------|----------|----------|----------|------------------|
|   1.us-west-2       |   us-west-2  |   54.214.84.101|   Server  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-0a12e67effb95a521)      |
|   2.us-west-2       |   us-west-2  |   54.213.9.215  |   Client  | [link to instance](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#InstanceDetails:instanceId=i-07929b2333abd47c0)      |

#### Useful links/commands/info AWS related:
* Link to instances: [here](https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#Instances:instanceState=running)
* When setting up instances I allowed all traffic to come through (via the AWS console) (I'm aware it's a bad practice. Just a temp change)
* .pem to ssh to instance attached (look access_key.pem)
* Before sshing to an instance, make sure to run `chmod 400 "access_key.pem"`
* To ssh to VM (1) (server): `ssh -i "access_key.pem" ubuntu@ec2-52-32-142-14.us-west-2.compute.amazonaws.com` (might need to change to root@)
* To ssh to VM (2) (client): `ssh -i "access_key.pem" ubuntu@ec2-35-92-34-130.us-west-2.compute.amazonaws.com` (might need to change to root@)


## Shell commands used in the assignment

#### General for moving around VMs:
* `vim` & `less` to ad-hoc investigate the contents of networking files
* `scp -i "access_key.pem" ubuntu@ec2-35-92-34-130.us-west-2.compute.amazonaws.com:/home/ubuntu/test.json .` - to download files later used for data analysis from 2nd VM (client)

#### General for network setup:
* `sudo tc qdisc add dev enX0 root netem delay 20ms` - to introduce a 20 sec delay, as per stack overflow: [here](https://serverfault.com/questions/787006/how-to-add-latency-and-bandwidth-limit-interface-using-tc)
* `sudo tc qdisc change dev enX0 root netem delay 20ms loss 0.005%` - to change packet loss to 0.005% or 0.01%.
* `sudo tc qdisc show dev enX0` - to show current tc set up (#TODO - Double check if the default limit 1000 for the buffer is appropriate for this project)
* `sysctl net.ipv4.tcp_congestion_control` - to check which congestion control is utilized in the current session
* `sudo sysctl -w net.ipv4.tcp_congestion_control=bbr` - to overwrite (temporarily) the networking protocol to be bbr
* `sudo sysctl -w net.ipv4.tcp_congestion_control=cubic` - to overwrite (temporarily) the networking protocol to be cubic

#### Large file transfer (using iperf):
* `sudo pkill iperf3` - to kill any uncessary iperf3 sesssions that would persist
* To set up server and listen for message on 1st VM: `iperf3 -s` (`-s` stands for server)
* To set up client (and send message to 1st VM from 2nv VM): `iperf3 -c {server_ip} -t 120 --json > (*).json` (eg. run iperf3 to send files to VM 1 for ~360 seconds, saving output of iperf3 into local .json file)
* Another way to record the data is using tcpdumb like this: `sudo tcpdump -i enX0 tcp port 5201 -w {filename}.pcap`

#### wgeting a website (as per TAs notes)
* Copy a website using httrack: `sudo httrack https://www.megamillions.com/`
* Record the data using: `sudo tcpdump -i enX0 tcp port 8808 -w {filename}.pcap`
* Wget the website using: `sudo wget http://52.32.142.14:8808/www.megamillions.com/index.html`
* The data will be pre-processed in python using scapy. The methodology is based on this stack overflow post: [link](https://stackoverflow.com/questions/42963343/reading-pcap-file-with-scapy)


#### Video streaming application (deprecated)
For this I'm utilsing ffmpeg, and specifically this StreamingGuide: [link](https://trac.ffmpeg.org/wiki/StreamingGuide) 
* Server (sending live screen grab to client) - `ffmpeg -f x11grab -s 1920x1200 -framerate 15 -i :0.0 -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x800 -f mpegts tcp://34.222.61.83:1234`
`ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 -c:v libx264 -preset fast -pix_fmt yuv420p -s 1280x720 -f mpegts tcp://34.222.61.83:1234 -progress stats.log`
* Client (listening for upcoming traffic)


## Data analyses
Data was gathered by setting loss rate and networking protocol on both serer & client.
Filenames:
| BBR/Cubic | % Loss Rate (Dropped Packets) | Application Type    | Filename                        | Jan | Ethan |
|-----------|-------------------------------|---------------------|---------------------------------|-----|-------|
| BBR       | 0%                            | Bulk Traffic        | BBR_0_BulkTraffic.json          |   Yes  |    |
| Cubic     | 0%                            | Bulk Traffic        | Cubic_0_BulkTraffic.json        |   Yes  |    |
| BBR       | 0.005%                        | Bulk Traffic        | BBR_0.005_BulkTraffic.json      |   Yes  |    |
| Cubic     | 0.005%                        | Bulk Traffic        | Cubic_0.005_BulkTraffic.json    |   Yes  |    |
| BBR       | 0.01%                         | Bulk Traffic        | BBR_0.01_BulkTraffic.json       |   Yes  |    |
| Cubic     | 0.01%                         | Bulk Traffic        | Cubic_0.01_BulkTraffic.json     |   Yes  |    |
| BBR       | 0%                            | Video Streaming     | BBR_0_Website.json       |     |    |
| Cubic     | 0%                            | Video Streaming     | Cubic_0_Website.json     |     |    |
| BBR       | 0.005%                        | Video Streaming     | BBR_0.005_Website.json   |     |    |
| Cubic     | 0.005%                        | Video Streaming     | Cubic_0.005_Website.json |     |    |
| BBR       | 0.01%                         | Video Streaming     | BBR_0.01_Website.json    |     |    |
| Cubic     | 0.01%                         | Video Streaming     | Cubic_0.01_Website.json  |     |    |




# Self notes
* Correct output of iftop showing bytes transferred when running curl (![alt text](image.png))
* It seems there *might* be some traffic being transferred. But unsure about that ...

