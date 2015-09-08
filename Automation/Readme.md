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
	cd ..
	cp configurations/openhab_default.cfg configurations/openhab.cfg

