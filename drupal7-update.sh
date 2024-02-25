#!/bin/bash

# Set variables
read -rp "Enter the list of users: " users
read -rp "Enter the Drupal 7 version (Ex: 7.92): " drupalversion
#users=(user1 user2 user3)
#drupalversion=7.92
drupal7file=https://ftp.drupal.org/files/projects/drupal-$drupalversion.tar.gz

for user in ${users[@]}; do

    public_html=/home/$user/public_html

    echo
    echo "#"
    echo "#"
    echo "# Start $user update"
    echo "#"
    echo "#"

    echo
    echo "> ($user) Create d-backup directory in user's public_html"
    mkdir $public_html/d-backup

    echo
    echo "> ($user) Move all core file to d-backup temp folder"
    cd $public_html && mv CHANGELOG.txt COPYRIGHT.txt cron.php includes index.php INSTALL.mysql.txt INSTALL.pgsql.txt install.php INSTALL.txt LICENSE.txt MAINTAINERS.txt misc modules profiles scripts themes update.php UPGRADE.txt xmlrpc.php d-backup

    echo
    echo "> ($user) Download and untar drupal file"
    curl -O $drupal7file -o $public_html && tar -xzpf $public_html/drupal-$drupalversion.tar.gz

    echo
    echo "> ($user) Move all new version files to public_html"
    cd $public_html/drupal-$drupalversion && mv authorize.php CHANGELOG.txt COPYRIGHT.txt cron.php includes index.php INSTALL.mysql.txt INSTALL.pgsql.txt install.php INSTALL.sqlite.txt INSTALL.txt LICENSE.txt MAINTAINERS.txt misc modules profiles scripts themes update.php UPGRADE.txt web.config xmlrpc.php $public_html

    echo
    echo "> ($user) Remove all created temp files and folders"
    cd $public_html && rm -rf d-backup drupal-$drupalversion*

    echo
    echo "> Restore '$user' permissions"
    chown -R $user: $public_html/*

done

echo
