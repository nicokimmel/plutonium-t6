FROM ubuntu:jammy

LABEL author="João Carlos Palma"


################################################################################
#                             Environment Variables                            #
################################################################################

ENV PLUTONIUM_DIRECTORY="/t6server/plutonium"
ENV SERVER_DIRECTORY="/t6server/server"
ENV IW4ADMIN_DIRECTORY="/t6server/admin"
ENV UPDATER_DIRECTORY="/t6server/updater"
ENV DOWNLOAD_DIRECTORY="/t6server/downloaded_files"
ENV STATUS_DIRECTORY="/t6server/status"

ENV WINEPREFIX="/root/.wine"
ENV WINEDEBUG="fixme-all"
ENV WINEARCH="win64"

ENV SERVER_KEY="YOUR_KEY_HERE"
ENV SERVER_PORT="4976"
ENV SERVER_MODE="Zombie"
ENV LAN_MODE="false"

ENV SERVER_MAX_CLIENTS=""
ENV SERVER_RCON_PASSWORD="admin"
ENV SERVER_MAP_ROTATION=""
ENV SERVER_PASSWORD=""

ENV ADMIN_PORT="1624"


################################################################################
#                            Container Provisioning                            #
################################################################################

# Create needed directories
RUN mkdir -p $PLUTONIUM_DIRECTORY \
			 $SERVER_DIRECROTY \
			 $IW4ADMIN_DIRECTORY \
			 $UPDATER_DIRECTORY \
			 $DOWNLOAD_DIRECTORY \
			 $STATUS_DIRECTORY

# Update the system
RUN apt-get update

# Installing needed packages
RUN apt-get install -y \
	wget \
	curl \
	zip \
	screen \
	gnupg2 \
	software-properties-common \
	xvfb \
	aria2 \
	apt-transport-https \
	dotnet-sdk-8.0 \
	dotnet-runtime-8.0 \
	avahi-daemon \
	avahi-utils

# Update the system
RUN apt-get upgrade -y


################################################################################
#                               Installing WINE                                #
################################################################################

COPY resources/install_wine.sh /t6server/install_wine.sh 
RUN chmod +x /t6server/install_wine.sh 
# [TODO] Run installer of the script in the server-launch.sh
RUN bash /t6server/install_wine.sh  && rm /t6server/install_wine.sh 


################################################################################
#                             Installing Updater                               #
################################################################################

COPY resources/check_updater.sh /t6server/check_updater.sh
#Make sure the script is executable by anyone
RUN chmod ugo+x /t6server/check_updater.sh


# Prepare server launch
WORKDIR /t6server
COPY resources/server-launch.sh .
RUN chmod +x server-launch.sh

CMD ["./server-launch.sh"]
