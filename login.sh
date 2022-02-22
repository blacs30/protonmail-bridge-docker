#!/usr/bin/expect

# Initialize pass
spawn gpg --generate-key --batch /proton/gpgparams
expect eof
spawn pass init pass-key
expect eof

if { $env(OTP_CODE) == "false" } {
    # Login
    spawn /usr/bin/protonmail-bridge --cli;
    expect ">>> "
    send "login\r"
    expect "Username:"
    send "$env(USERNAME)\r"
    expect "Password:"
    send "$env(PASSWORD)\r"
    expect ">>> "
    send "list\r"
    expect ">>> "
    send "info\r"
    expect ">>> "
    send "exit\r"
    expect eof
} else {
    # Login
    spawn /usr/bin/protonmail-bridge --cli;
    expect ">>> "
    send "login\r"
    expect "Username:"
    send "$env(USERNAME)\r"
    expect "Password:"
    send "$env(PASSWORD)\r"
    expect "Two factor code:"
    send "$env(OTP_CODE)\r"
    expect ">>> "
    send "list\r"
    expect ">>> "
    send "info\r"
    expect ">>> "
    send "exit\r"
    expect eof
}