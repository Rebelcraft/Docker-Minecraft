#!/bin/ash
sleep 3
CHK_FILE="/home/container/${SERVER_JARFILE}"

cd /home/container
if [ -f $CHK_FILE ]; then
   echo "A ${SERVER_JARFILE} file already exists in this location, not downloading a new one."
else
    if [ ${BUNGEE_VERSION} == "latest" ]; then
        LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/HexagonMC/BungeeCord/releases/latest)
        LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\(.*\)".*/\1/')  
        DL_PATH=https://github.com/HexagonMC/BungeeCord/releases/download/$LATEST_VERSION/BungeeCord.jar
    else
        DL_PATH=https://github.com/HexagonMC/BungeeCord/releases/download/${BUNGEE_VERSION}/BungeeCord.jar
    fi

    echo "> curl -sSL ${DL_PATH} -o ${SERVER_JARFILE}"
    curl -sSL ${DL_PATH} -o ${SERVER_JARFILE}
fi

if [ -z "$STARTUP"  ]; then
    echo "$ java -jar ${SERVER_JARFILE}"
    java -jar ${SERVER_JARFILE}
else
    # Output java version to console for debugging purposes if needed.
    java -version

    # Pass in environment variables.
    MODIFIED_STARTUP=`echo ${STARTUP} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
    echo "$ java ${MODIFIED_STARTUP}"

    # Run the server.
    java ${MODIFIED_STARTUP}
fi
