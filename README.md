# Tic-tac-toe #

This app implements the game tic-tac-toe with Julia and React. Logic of the game is divided into backend and frontend services, Julia being used in the backend to compute bot player's moves in the game board and React in the frontend to provide interactive user interface for the game.

In general, in order to use this app, Docker and Docker compose are mandatory dependencies.

## Usage ##

This section gives a short introduction on how to use this app in development mode.

To run the app, run the following command in a shell.

```bash
docker-compose -f docker-compose.yml up
```

After the services have started, open localhost:3000 in a browser of your choice.

When finished with the app, bring everything down and remove containers and volumes by running

```bash
docker-compose down --volumes
```

Note that volume mappings for services are commented out in this compose file.

## Usage in Raspberry Pi 3 ##

In this optional section, the app is deployed to Raspberry Pi 3 (armv7l) and served from there to local network using Nginx. To do this successfully, the mandatory first step is to install Docker and Docker compose for the Pi. It's also a good practise to set the Pi's IP address static if not done previously. Furthermore, a word of caution regarding the firewall rules of the raspberry pi: Docker bypasses UFW rules and the port 3000 might be exposed to the public network depending on the firewall settings on your internal network.

As of writing this, there are some compatibility issues between alpine 3.14 and Raspberry Pi (affecting service *game*) and it required me to upgrade package *libseccomp2* as follows

```bash
wget http://ftp.de.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb
dpkg -i libseccomp2_2.5.1-1_armhf.deb
```


```bash
docker-compose -f docker-compose-arm.yml up
```

