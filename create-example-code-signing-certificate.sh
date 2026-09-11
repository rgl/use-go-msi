#!/bin/bash
set -eux

ca_file_name=example-code-signing-ca
ca_common_name='Example Code Signing CA'

file_name=example-code-signing
common_name='example.com'

# create code signing CA certificate.
openssl genrsa \
    -out $ca_file_name-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $ca_file_name-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$ca_common_name" \
    -key $ca_file_name-keypair.pem \
    -out $ca_file_name-csr.pem
openssl x509 -req -sha256 \
    -signkey $ca_file_name-keypair.pem \
    -extensions a \
    -extfile <(echo "[a]
        basicConstraints=critical,CA:TRUE,pathlen:0
        keyUsage=critical,keyCertSign,cRLSign
        ") \
    -days 365 \
    -in  $ca_file_name-csr.pem \
    -out $ca_file_name-crt.pem
openssl x509 -noout -text -in $ca_file_name-crt.pem

# create code signing certificate.
openssl genrsa \
    -out $file_name-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $file_name-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$common_name" \
    -key $file_name-keypair.pem \
    -out $file_name-csr.pem
openssl x509 -req -sha256 \
    -CA $ca_file_name-crt.pem \
    -CAkey $ca_file_name-keypair.pem \
    -CAcreateserial \
    -extensions a \
    -extfile <(echo "[a]
        keyUsage=critical,digitalSignature
        extendedKeyUsage=critical,codeSigning
        ") \
    -days 365 \
    -in  $file_name-csr.pem \
    -out $file_name-crt.pem
openssl pkcs12 -export \
    -inkey    $file_name-keypair.pem \
    -in       $file_name-crt.pem \
    -out      $file_name.p12 \
    -passout  pass:
openssl pkcs12 -info \
    -in $file_name.p12 \
    -passin pass: \
    -nodes \
    2>/dev/null \
    | openssl x509 -noout -text
