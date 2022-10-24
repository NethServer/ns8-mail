# The controller is behind lighttpd reverse proxy
bind_socket = "/run/rspamd-controller.sock mode=0666";
secure_ip = "127.0.0.1";
