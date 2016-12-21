#!/bin/bash

# append path variable in /etc/environment

sudo sed -i '/^PATH/s/"$/:\/opt\/packer"/g' /etc/environment