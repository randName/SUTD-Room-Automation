# Automation
[OpenHAB](http://www.openhab.org/) is a "vendor and technology agnostic open source automation software".

Basically, it's a really good framework and the only drawback is that it uses Java.

### Installing OpenHAB
Currently on a Raspberry Pi running [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) (May 2015)

Get the latest [distribution release](https://github.com/openhab/openhab/releases/) number (currently 1.6.1).

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
[MQTT](http://mqtt.org/) is a communication protocol that is a [lot more efficient for IoT data](http://www.element14.com/community/community/design-challenges/forget-me-not/blog/2014/09/17/fmnxx-mqtt--the-language-of-iot).

    wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
    sudo apt-key add mosquitto-repo.gpg.key
    rm mosquitto-repo.gpg.key
    cd /etc/apt/sources.list.d/
    sudo wget http://repo.mosquitto.org/debian/mosquitto-wheezy.list
	sudo apt-get update
	sudo apt-get install mosquitto mosquitto-clients

### Configuring OpenHAB to work with Mosquitto

Replace

    #mqtt:<broker>.url=tcp://<host>:1883
    #mqtt:<broker>.clientId=<clientId>

with

    mqtt:localbroker.url=tcp://localhost:1883
    mqtt:localbroker.clientId=openHAB

### Other references
- [1. Setting up OpenHAB](https://openhardwarecoza.wordpress.com/2015/03/29/openhab-mqtt-arduino-and-esp8266-part-1-setting-up-your-environment/)
- [2. MQTT and ESP8266](https://openhardwarecoza.wordpress.com/2015/03/29/openhab-mqtt-arduino-and-esp8266-part-2-publish-subscribe-command-state-and-wtfs/)
- [OpenHAB Control of LED via MQTT and ESP8266](https://mydiyelectronics.wordpress.com/2015/01/26/135/)
- [OpenHAB, Python and MQTT](https://mydiyelectronics.wordpress.com/2015/03/09/openhab-python-and-mqtt/) (Why doesn't he just do the conversion on the ESP8266?)