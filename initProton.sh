#!/bin/bash

set -eufo pipefail

BRIDGE=Desktop-Bridge

#### INIT

if ! [ -f ./initialized ]; then

  gpg --generate-key --batch /gpgparams
  pass init pass-key

  $BRIDGE --cli <<EOF
login
$EMAIL
$PASSWORD
EOF

  touch ./initialized
fi

$BRIDGE --cli <<EOF | egrep '(Username|Password)' | sort -ru
info
EOF

# socat will make the conn appear to come from 127.0.0.1
# ProtonMail Bridge currently expects that.
# It also allows us to bind to the real ports :)
socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

# Fake a terminal, so it does not quit because of EOF...
rm -f faketty
mkfifo faketty
cat faketty | $BRIDGE --cli
