#!/bin/bash
sudo apt-get install -y git
# Prompt the user to enter their Git username
read -p "Enter your Git user Name: " git_username 
# Prompt the user for their email address
read -p "Enter your Git user email: " user_email
git config --global user.email "$user_email"
git config --global user.name "$git_username"
