FROM ubuntu:18.04

# Set the default shell to bash
#SHELL ["/bin/bash", "-c"]


# Fake sudo script
# This is needed to be compatible with the dandelion.sh script
# and not need to install sudo (we are root in the container)
# It runs all arguments as a normal command
RUN echo '#!/usr/bin/env bash\n"$@"' > /usr/bin/sudo && chmod +x /usr/bin/sudo


#RUN apt-get update && \
    #apt-get upgrade -y && \
    #apt-get install -y git


COPY repos/ /repos


# Run dandelion-generator install script
WORKDIR /repos/uir
# Send four y's as input to dandelion script to install everything
RUN printf 'y\ny\ny\ny\n' | ./scripts/dandelion.sh

# Publish dandelion-lib locally
WORKDIR /repos/uir-lib
RUN sbt 'publishLocal'

# Make and test dandelion-generator
WORKDIR /repos/dandelion-generator/dependencies/Tapir-Meta
# When sourcing setup-env.sh the shell cwd must be the directory of the script because it uses $(pwd)
RUN . ./setup-env.sh && cd ../.. &&  mkdir build &&  cd build && cmake -DLLVM_DIR=/repos/uir/dependencies/Tapir-Meta/tapir/build/lib/cmake/llvm/ -DTAPIR=ON .. && make

# Adding clang and dandelion to PATH
ENV PATH="/repos/uir/dependencies/Tapir-Meta/tapir/build/bin:${PATH}"
ENV PATH="/repos/uir/build/bin:${PATH}"

WORKDIR /repos/uir/
RUN cd build \
        && cd tests/c \
        && make all
