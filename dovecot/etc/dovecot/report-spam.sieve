#
# Invoke Rspamd spam learning
#

require ["vnd.dovecot.pipe", "copy"];

pipe :copy "rspamc-wrapper" [ "learn_spam" ];
