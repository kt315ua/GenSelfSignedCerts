#!/bin/bash

# Create root-CA key
echo "Create root-CA key"
openssl genrsa -out fakeSelfCA.key 4096
# openssl x509 -text -noout -in fakeSelfCA.crt


# Create root-CA cert
echo "Create root-CA cert"
openssl req -x509 -new -key fakeSelfCA.key -days 1096 -out fakeSelfCA.crt \
  -subj "/C=UA/ST=Some-State/L=Some-City/O=Some org/OU=Some OU/CN=CA.DNS" \
  -extensions v3_req

# Gen private key
echo "Create private key"
openssl genrsa -out fakeSelfCert.key 4096

# Create fakeSelfCert cert
echo "Create fakeSelfCert cert"
openssl req -new -key fakeSelfCert.key -out fakeSelfCert.csr \
  -subj "/C=UA/ST=Some-State/L=Some-City/O=Some org/OU=Some OU/CN=CERT.DNS" \
  -extensions v3_req

# Self-signed site cert
echo "Self-signed site cert by CA"
openssl x509 -req -in fakeSelfCert.csr -CA fakeSelfCA.crt -CAkey fakeSelfCA.key -CAcreateserial -out fakeSelfCert.crt -days 365 \
    -extfile /etc/ssl/openssl.cnf  -extensions v3_req


