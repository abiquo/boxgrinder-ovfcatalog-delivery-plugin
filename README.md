# Boxgrinder OVFCatalog

Using Boxgrinder to build and upload appliances to the Abiquo OVFCatalog

This tutorial will guide you to create an Ubuntu Oneiric appliance using [Boxgrinder](http://boxgrinder.org) and upload it to the Abiquo OVFCatalog (PlayRepo) service.

**WARNNG**
OVFCatalog is a brand new 2.0 service, not yet released.

# Pre-requisites

You need an Ubuntu based Boxgrinder meta-appliance (used to build other appliances). Get it from:

    http://mirror.abiquo.com/appliances/boxgrinder-meta-ubuntu-oneiric-amd64.vmdk

and deploy it.

# Install the Boxgrinder ovfcatalog-delivery-plugin to the meta-appliance

SSH to the boxgrinder meta-appliance. Default password for the root user is 'boxgrinder'.

    $ ssh root@my-boxgrinder-meta-app

Install required packages:

    $ apt-get install libcurl4-openssl-dev build-essential git

Install the plugin

    $ gem install --no-ri --no-rdoc boxgrinder-ovfcatalog-delivery-plugin

# Download sample appliance definitions

You can download some Ubuntu based Boxgrinder appliance definitions from [here](http://github.com/rubiojr/boxgrinder-appliances). Let's check them out using git:

    $ git clone http://github.com/rubiojr/boxgrinder-appliances

We’ll use a Ubuntu appliance definition to generate a new appliance:

    $ cd boxgrinder-appliances/ubuntu-jeos

    $ boxgrinder-build -l boxgrinder-ubuntu-plugin,ovfcatalog-plugin \
                               -d ovfcatalog \
                               --delivery-config host:rs.bcn.abiquo.com,port:9000 \
                               oneiric.appl

This will build the Ubuntu Oneiric appliance and upload it to the OVFCatalog service installed in 'rs.bcn.abiquo.com' and  listening on port '9000'.



Browse the OVFCatalog and you'll see a new appliance named 'ubuntu-oneiric' in QCOW2 format.

#OVFCatalog plugin configuration parameters

The ovfcatalog Boxgrinder plugin accepts the following list of config parameters:

**host:** the OVFCatalog host.
**port:** the OVFCatalog port.
**category:** the OVFCatalog category the appliance will have.
**icon_path:** the URL of the appliance icon.
**host:** the OVFCatalog host
**name:** the appliance name.
**description:** the appliance description.
**ram:** the amount of RAM the appliance will have.
**cpu:** the number of CPUs the appliance will have.

All the config parameters have default values and none of them are mandatory. Use the **--delivery-config** Boxgrinder parameter to configure the appliance upload to fit your needs.


# Copyright

Copyright (c) 2011 Abiquo Inc. See LICENSE.txt for
further details.

