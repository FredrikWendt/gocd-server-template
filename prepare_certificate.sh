#!/bin/bash

#The order of certificates must be from server to rootCA, as per RFC2246 section 7.4.2.
#RUN $ cat example.crt intermediate.crt [intermediate2.crt] ... rootCA.crt > cert-chain.txt
#RUN $ openssl pkcs12 -export -inkey example.key -in cert-chain.txt -out example.pkcs12

KEYSTORE_PASSWORD=serverKeystorepa55w0rd

cat gocd.wendt.io.crt RapidSSL-SHA256-CA-G3.pem > combined.pem

# apparently, the key needs a passphrase
openssl rsa -des3 -in gocd.wendt.io.key -out gocd.wendt.io.key-with-pass -passout pass:$KEYSTORE_PASSWORD

# create pkcs12 format, with key, intermediate CA cert, cert
openssl pkcs12 -inkey gocd.wendt.io.key-with-pass -in combined.pem -export -out gocd.wendt.io.pkcs12 -passin pass:$KEYSTORE_PASSWORD -passout pass:$KEYSTORE_PASSWORD

# import pkcs12 into keystore
keytool -importkeystore -srckeystore gocd.wendt.io.pkcs12 -srcstoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD -destkeystore keystore -srcalias 1 -destalias cruise -storepass $KEYSTORE_PASSWORD

# did it work?
keytool -keystore keystore -storepass $KEYSTORE_PASSWORD -list -v -alias cruise

# a truststore needs to be available too, with the same passphrase, let's copy the JVM's default
#keytool -importkeystore -noprompt -srckeystore /etc/ssl/certs/java/cacerts -srcstorepass changeit -destkeystore /etc/gocd.wendt.io-truststore -deststorepass $KEYSTORE_PASSWORD -noprompt
cp reference-truststore /etc/gocd.wendt.io-truststore

# put into place and cleanup
mv keystore /etc/gocd.wendt.io-keystore
rm -rf /tmp/certs

