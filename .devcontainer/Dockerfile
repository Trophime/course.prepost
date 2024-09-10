#FROM node:16.20.2-bookworm
# try to use opengl noble ??
# if so, feelpp need to be install and USERNAME defined if not exist: check with getent ??
FROM ubuntu:24.04

# Set one or more individual labels
LABEL feelppdoc.lncmi.version="0.0.1-beta"
LABEL vendor1="Lncmi"
LABEL feelppdoc.lncmi.release-date="2024-05-09"
LABEL feelppdoc.lncmi.is-production=""

USER root
ENV NODE_PATH=/usr/local/share/.config/yarn/global/node_modules

# Setup demo environment variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    OMPI_MCA_btl_vader_single_copy_mechanism=none

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=feelpp
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apt-file && \
    apt-file update && \
    apt-get -y install curl findutils jq yq coreutils bash-completion locate nmap vim-nox gpg openssh-client

# Install stuff for antora preview
# test without caddy deb and guard-livereload gem
RUN apt-get update && \
    apt-get -y install ruby-dev ruby libnotify4 locate && \
    gem install --no-document guard guard-shell libnotify && \
    apt-get -y remove ruby-dev && \
    updatedb


# Install python stuff
# python3-watchdog seems not be to working as guardfile
# use python3-pyvirtualdisplay: wrapper for Xvfb,.. instead of python3-xvfbwrapper?
RUN apt-get -y install python-is-python3 python3-venv python3-xvfbwrapper libgl1-mesa-dev

# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.\
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    # [Optional] Add sudo support for the non-root user
    apt-get install -y sudo lsb-release && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME


# add github ssh key
RUN mkdir -p ~$USERNAME/.ssh/ && \
    ssh-keyscan github.com >> ~$USERNAME/.ssh/known_hosts && \
    chown -R $USER_UID.$USER_GID ~$USERNAME/.ssh

USER $USERNAME

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# EXPOSE 2020
# EXPOSE 35729
