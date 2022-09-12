{% if env.adminpw %}
password = "{= env.adminpw|pbkdf =}";
enable_password = "{= env.adminpw|pbkdf =}";
{% endif %}
