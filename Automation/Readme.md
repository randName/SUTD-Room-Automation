# Automation
[OpenHAB](http://www.openhab.org/) is a "vendor and technology agnostic open source automation software".

Basically, it's a really good framework and the only drawback is that it uses Java.

### Installing OpenHAB
on a Raspberry Pi running [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) (May 2015)

Get the latest [distribution release](https://github.com/openhab/openhab/releases/) number.

    sudo mkdir /opt/openhab
	cd /opt/openhab
	sudo chown pi .
	wget https://github.com/openhab/openhab/releases/download/v[VERSION]/distribution-[VERSION]-runtime.zip
    unzip distribution-[VERSION]-runtime.zip
	rm distribution-[VERSION]-runtime.zip
	cd addons
	wget https://github.com/openhab/openhab/releases/download/v[VERSION]/distribution-[VERSION]-addons.zip
	unzip distribution-[VERSION]-addons.zip
	rm distribution-[VERSION]-addons.zip

Create a copy of the default config file for editing

	cp /opt/openhab/configurations/openhab_default.cfg /opt/openhab/configurations/openhab.cfg

Refer to [OpenHAB Tricks](https://github.com/openhab/openhab/wiki/Samples-Tricks) to start automatically as a service.

### Installing Mosquitto (MQTT Broker)

    wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
    sudo apt-key add mosquitto-repo.gpg.key
    rm mosquitto-repo.gpg.key
    cd /etc/apt/sources.list.d/
    sudo wget http://repo.mosquitto.org/debian/mosquitto-wheezy.list
	sudo apt-get update
	sudo apt-get install mosquitto mosquitto-clients

### Configuring OpenHAB to work with Mosquitto

    