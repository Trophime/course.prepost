#!/bin/bash
set +x

# install feelpp stuff
if [ ! -f /etc/apt/sources.list.d/feelpp.list ]; then
    echo "Installing feelpp packages"
    DIST=$(lsb_release -cs)
    sudo apt-get install wget gpg
    wget -qO - http://apt.feelpp.org/apt.gpg | sudo apt-key add -
    echo "deb http://apt.feelpp.org/debian/$DIST $DIST latest" | sudo tee -a /etc/apt/sources.list.d/feelpp.list
    rm -f feelpp.gpg
    sudo apt -qq update
    sudo apt-get -y install  --no-install-recommends \
               python3-feelpp-toolboxes-coefficientformpdes \
       	       python3-feelpp-toolboxes-thermoelectric python3-feelpp-toolboxes-electric python3-feelpp-toolboxes-heat \
      	       python3-feelpp-toolboxes-fluid python3-feelpp-toolboxes-solid \
      	       python3-feelpp-toolboxes-hdg; \
fi

# install python stuff
if [ $dist == "Ubuntu" ]; then
  sudo apt install -y python-is-python3 python3-venv 
  python3 -m venv --system-site-packages .venv
  source .venv/bin/activate
  pip3 install -r requirements.txt
else
  source .venv/bin/activate
fi

# install utilities tools
sudo apt install -y pandoc

# install firefox for LiveServer
dist=$(lsb_release -ds | cut -d " " -f 1)
echo "Install for dist=${dist}"
if [ $dist == "Ubuntu" ]; then
    sudo apt -y install software-properties-common
    sudo add-apt-repository -y ppa:mozillateam/ppa >> /tmp/output.txt 2>&1
    sudo apt update
fi
sudo apt install -y firefox-esr libpci-dev
if [ $dist == "Ubuntu" ]; then
    sudo ln -sf /usr/bin/firefox-esr /usr/bin/firefox
fi

# install
# sudo chown -R vscode:vscode . # in wsl remote container
# if base image is not node:xxxx 
sudo apt install -y npm
npm install

# Generate website
npx antora --cache-dir=public/.cache/antora site.yml

# Launch Guard for files
echo ""
echo " ___________________________________________________________________________"
echo "|                                                                           |"
echo "| Use VScode LiveServer to view the doc                                     |"
echo "| Click on the icon at the bottom right of VSc windows to start the server  |"
echo "|___________________________________________________________________________|"
echo ""
# sudo caddy start
# signalListener .. # from antora-preview but this seems buggy
guard -p --no-interactions -w docs public
# watchmedo auto-restart -d ./docs/ -p '*.adoc' --recursive `./antora-run.sh`
