FROM gocd/gocd-server:15.2.0
COPY put_keystore_in_place.sh /etc/my_init.d/
COPY certs /tmp/certs
COPY prepare_certificate.sh /tmp/certs/
RUN cd /tmp/certs ; ./prepare_certificate.sh
