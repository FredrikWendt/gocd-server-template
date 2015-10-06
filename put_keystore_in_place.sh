#!/bin/bash

#
# Because /etc/go is a VOLUME, any modifications to it are lost,
# so instead we make the modifications needed when the container
# starts.
#
if [ -z "$GOCD_KEYSTORE" ] ; then
    echo "Using default keystore, a new unique SSL/TLS key will be used"
    exit 0
fi

echo "Using $GOCD_KEYSTORE and $GOCD_TRUSTSTORE"
mv $GOCD_KEYSTORE   /etc/go/keystore
mv $GOCD_TRUSTSTORE /etc/go/truststore

rm /etc/my_init.d/put_keystore_in_place.sh
