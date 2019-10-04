Dandelion-Docker
===============

With this repository you can build a Docker image with all Dandelion projects installed.


Quick Start
===========
In the quick start section we describe how to install docker on your system, build the docker image with dandelion tools installed on the image. And finally we explain how can you test and run a example.


## Step 1 -- Installing Docker

First, update your existing list of packages:

```bash
sudo apt update
```

Next, install a few prerequisite packages which let apt use packages over HTTPS:

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

Then add the GPG key for the official Docker repository to your system:

``` bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Add the Docker repository to APT sources:

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
```

Next, update the package database with the Docker packages from the newly added repo:

```bash
sudo apt update
```

Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:

```bash
apt-cache policy docker-ce
```

You’ll see output like this, although the version number for Docker may be different:

```
Output of apt-cache policy docker-ce
docker-ce:
  Installed: (none)
  Candidate: 18.03.1~ce~3-0~ubuntu
  Version table:
     18.03.1~ce~3-0~ubuntu 500
        500 https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
```

Notice that docker-ce is not installed, but the candidate for installation is from the Docker repository for Ubuntu 18.04 (bionic).

Finally, install Docker:

```bash
sudo apt install docker-ce
```

Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it’s running:

```bash
sudo systemctl status docker
```

The output should be similar to the following, showing that the service is active and running:

```
Output
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2018-07-05 15:08:39 UTC; 2min 55s ago
     Docs: https://docs.docker.com
 Main PID: 10096 (dockerd)
    Tasks: 16
   CGroup: /system.slice/docker.service
           ├─10096 /usr/bin/dockerd -H fd://
           └─10113 docker-containerd --config /var/run/docker/containerd/containerd.toml
```


## Step 2 -- Building Docker image

To build Dandelion docker image file you only need to run the `build.sh` script. This script will take care of cloning and building the necessary repositories and it runs docker commands to build the iamge.

```bash
./build.sh
```

Please remember this step may take long for half an hour or more, since for building docker image you we need to build specific version of [LLVM/TAPIR (v6.0)](http://cilk.mit.edu/tapir/), [Verilator](https://www.veripool.org/wiki/verilator) and a few more packages.

*In the next version we will distribute pre-built version of TAPIR and Verilator along with our image*

## Step 3 -- Runing our dandelion toy example

[Dandelion-sim](https://github.com/sfu-arch/dandelion-sim) is our simulation framework for testing our designs. After building and installing prerequisites packages for dandelion project, someone can take output of dandelion-generator and plug it to dandelion-sim framework to run the cycle accurate simulation. For more details please look at our documentation for each project and our `dandelion-bootcamp` which walks trough each step of building and accelerator from your software using dandelion.
In this section, we only explain how someone can run our toy example on docker image.

To run dandelion-sim you need to run the following command:

```bash
sudo docker run --rm -it --entrypoint bash dandelion -c "cd /repos/dandelion-sim && make run_chisel"
```


The output of the command should look like:

```
Input: a =                 4096, b =                 8192, const =          5, len =         10
[LOG] [Test14] [TID-> 0] [BB]   bb_entry0: Output [F] fired @    30
[LOG] [Test14] [TID-> 0] [COMPUTE] binaryOp_add1: Output fired @    31, Value:         15 (        10 +          5 )
[LOG] [Test14] [TID-> 0] [LOAD] ld_0: Memreq fired @    31, Addr:      4096
[LOG] [MemController] [MemReq]: Addr:       4096, Data:          0, IsWrite: LD
[LOG] [MemController] [MemResp]: Data:          0, IsWrite: LD
[LOG] [Test14] [TID-> 0] [LOAD] ld_0: Memresp fired @    39, Value:          0
[LOG] [Test14] [TID-> 0] [LOAD] ld_0: Output fired @    40, Address:      4096, Value:          0
[LOG] [Test14] [TID-> 0] [COMPUTE] binaryOp_add12: Output fired @    41, Value:         15 (        15 +          0 )
[LOG] [MemController] [MemReq]: Addr:       8192, Data:         15, IsWrite: ST
[LOG] [MemController] [MemResp]: Data:          0, IsWrite: ST
[LOG] [Test14] [TID-> 0] [STORE]st_3: Fired @    51 Mem[      8192 ] =         15
[LOG] [Test14] [TID-> 0] [RET] ret_4: Output fired @    54
[LOG] [MemController] [MemResp]: Data:         15, IsWrite: ST
[PASS] cycles:  30 a:10 b: 5
```

This output says all the tools are installed properly and the toy example has successfully passed our test harness.

Authors:
========
* Eirik Smithsen <eirism@stud.ntnu.no>
* Amirali Sharifian <amiralis@sfu.ca>
