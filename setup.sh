#!/bin/sh

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)

# for development usage
#set -e # bail on first error
#set -u # bail on unbound variable reference
#set -x # print command before executing

VirtualBoxUrl='http://download.virtualbox.org/virtualbox/4.3.6/VirtualBox-4.3.6-91406-OSX.dmg'
VagrantUrl='https://dl.bintray.com/mitchellh/vagrant/Vagrant-1.4.3.dmg'
DockerOSXUrl='https://raw.github.com/noplay/docker-osx/0.8.0/docker-osx'

VBoxManage='/usr/bin/VBoxManage'
hdiutil='/usr/bin/hdiutil'
curl='/usr/bin/curl'

tmpDir='/tmp'

InstallVirtualBox() {
  cd $tmpDir
  $curl -Lo virtualbox.dmg $VirtualBoxUrl
  $hdiutil mount virtualbox.dmg
  sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /
  $hdiutil unmount /Volumes/VirtualBox
  rm virtualbox.dmg
}

InstallVagrant() {
  cd $tmpDir
  $curl -Lo vagrant.dmg $VagrantUrl
  $hdiutil mount vagrant.dmg
  sudo installer -package /Volumes/Vagrant/Vagrant.pkg -target /
  $hdiutil unmount /Volumes/Vagrant
  rm vagrant.dmg
}

InstallVagrantPlugins() {
  # Must not be in the same directory as a Vagrantfile
  # or it might try to load plugins that don't exist
  cd $tmpDir

  vagrant plugin install vagrant-vbguest
}

InstallDockerOSX() {
  cd $tmpDir
  $curl -Lo docker-osx $DockerOSXUrl
  chmod +x docker-osx
  mv docker-osx /usr/local/bin/docker-osx
}

InstallFig() {
  pip install fig -U
}


Cleanup() {
  echo "${GREEN}Cleaning...${NORMAL}"
  $hdiutil unmount -quiet /Volumes/VirtualBox 2>&1 >/dev/null
  $hdiutil unmount -quiet /Volumes/Vagrant 2>&1 >/dev/null

  cd $tmpDir
  rm -f vagrant.dmg virtualbox.dmg
}

ask() {
  name=$1
  read -p "${GREEN}Do you wish to install $name (y/N) ${NORMAL}" yn
  case $yn in
    [Yy]* ) answer=true;;
    * ) answer=false;;
  esac
  echo $answer
}

Stop() {
  # assume that VirtualBox is not installed if $VBoxManage doesn't exist
  [ -x $VBoxManage ] || return
  read -p "${GREEN}All VirtualBox machines have to be stopped. Do you want me to do this now? (y/N) ${NORMAL}" yn
  case $yn in
    [Yy]* ) answer=true;;
        * ) answer=false;;
  esac
  $answer || exit

  $VBoxManage list runningvms | cut -d' ' -f1 | xargs -I% $VBoxManage controlvm % poweroff soft
  while [ "`$VBoxManage list runningvms`" != "" ]
  do
    echo "Waiting for VMs to shutdown..."
    sleep 3
  done
}

# Ask for the password now so the rest of the install is uninterrupted
sudo true

virtualbox=$(ask 'VirtualBox')
vagrant=$(ask 'Vagrant')
vagrant_plugins=$(ask 'Vagrant Plugins')
docker_osx=$(ask 'docker-osx')
fig=$(ask 'Fig')

$virtualbox && Stop && InstallVirtualBox
$vagrant && InstallVagrant
$vagrant_plugins && InstallVagrantPlugins
$docker_osx && InstallDockerOSX
$fig && InstallFig

Cleanup
