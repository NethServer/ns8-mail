#
# Options -- https://rspamd.com/doc/configuration/options.html
#

# rspamd 4.x: content URLs (PDF, etc.) are included by default in task:get_urls()
# Disable to preserve old behavior and avoid unintended RBL hits
include_content_urls = false;

dns {
    timeout = 1s;
    sockets = 16;
    retransmits = 5;
    nameserver = ["127.0.0.1:11336:1"]; # local unbound instance
}
max_message = 104857600;
