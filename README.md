# Vagrant: PHP Development Box

##Overview
This Vagrant box is built from a fresh Debian Wheezy (7.1) x86_64

The following is used:
- PHP 5.5.4 (PHP-FPM via [Dotdeb](http://www.dotdeb.org/category/php/))
  - cURL
  - PEAR
  - memcached
  - mcrypt
  - xDebug
  - Xhprof
  - redis
  - mysqlnd
  - [PHP QA Tools](http://phpqatools.org/)
- Nginx
- Maria DB 10 (Latest available 10.x)
- Redis 2.6.16 (Latest available 2.6.x via [Dotdeb](http://www.dotdeb.org/category/redis/))

## Installation

The following instructions are tailored for OSX users, however should work fine for Linux and Windows too.

### Requirements

- Vagrant (1.3.4+)
- Vagrant hosts-updater plugin (optional: Adds entries into your hosts file for ease of use)
- VirtualBox (See below for more information)

#### Virtualbox Requirement

Virtualbox is required for modifying the Vitual Machine's Memory on boot. The Box itself defaults to 384 MB RAM, however this can be increased to a specific desired amount (default of 1024mb) via the Vagrantfile.

You need to comment out the following line if you wish to use this set-up without having Virtualbox installed.

```ruby
vb.customize ["modifyvm", :id, "--memory", "1024"]
```

### Install Vagrant

Download and install vagrant (1.3.4+): http://downloads.vagrantup.com

#### Install the Vagrant Hosts Updater plugin (optional)
```sh
$ vagrant plugin install vagrant-hostsupdater
```

### Clone the git repository

Clone the repository in your prefered location, initialize submodules, and update:

```sh
$ git clone https://github.com/Megasaxon/php-vagrant-devbox.git
```

### Vagrant up

From the root of the directory of the cloned project, vagrant up:

```sh
$ cd php-vagrant-devbox
$ vagrant up
```

*Note:* You may be prompted with your account password during the point where NFS is enabled (on OSX & Linux). You must provide your password to proceed.

## Usage
The host IP is *192.168.1.121*. 
Access the web via *http(s)://example.com/* (Assuming you set up a hosts record and/or use the hostsupdater plugin!)