#!/usr/bin/env bash
mkdir repos
pushd repos
git clone https://github.com/sfu-arch/uir.git
git clone https://github.com/sfu-arch/uir-lib.git
git clone https://github.com/sfu-arch/uir-sim.git
popd
sudo docker build -t uir .
