#!/usr/bin/env bash
mkdir repos
pushd repos
git clone ssh://git@cs-git-research.cs.surrey.sfu.ca:24/amiralis/dandelion-generator.git
git clone ssh://git@cs-git-research.cs.surrey.sfu.ca:24/amiralis/dandelion-lib.git
git clone ssh://git@cs-git-research.cs.surrey.sfu.ca:24/amiralis/dandelion-sim.git
popd
sudo docker build -t dandelion .
