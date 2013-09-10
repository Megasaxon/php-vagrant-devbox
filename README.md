# Vagrant: PHP Development Box

##Overview
This Vagrant box is built from a fresh Ubuntu Raring Ringtail (13.04) x86_64

The following is used:
- PHP 5.5.3 (PHP-FPM)
- Nginx

## Installation

The following instructions are specific to OSX.

### Requirements

- OSX 10.8+
- Vagrant
- Vagrant hosts-updater plugin (optional: Adds entries into your hosts file for ease of use)

### Install Vagrant

Download and install vagrant (1.2.2+): http://downloads.vagrantup.com

#### Install the Vagrant Hosts Updater plugin (optional)
```sh
$ vagrant plugin install vagrant-hostsupdater
```

### Clone the git repository

Clone the repository in your prefered location, initialize submodules, and update:

```sh
$ git clone https://github.com/megasaxon/php-vagrant-devbox
```

### Vagrant up

From the root of the directory of the cloned project, vagrant up:

```sh
$ cd php-vagrant-devbox
$ vagrant up
```

*Note:* You may be prompted with your OSX password during the point where NFS is enabled. You must provide your password to proceed.

## Usage


The host IP is *192.168.1.121*.

The following ports have been exposed for the following services:
* Nginx: 80
