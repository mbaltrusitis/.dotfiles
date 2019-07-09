#!/usr/bin/env bash

echo "I: Installing snap-based images";
sudo snap refresh;
sudo snap install --classic slack;
sudo snap install dbeaver-ce;
sudo snap install mailspring;
sudo snap install signal-messenger;
sudo snap install --classic google-cloud-sdk;
