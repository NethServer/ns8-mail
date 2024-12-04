#
# Options -- https://rspamd.com/doc/configuration/options.html
#
dns {
    timeout = 1s;
    sockets = 16;
    retransmits = 5;
    nameserver = ["127.0.0.1:11336:1"]; # local unbound instance
}
max_message = 104857600;
