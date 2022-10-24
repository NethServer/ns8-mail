#
# Invoke Rspamd ham learning, unless destination is Trash
#

require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment" ];

if environment :matches "imap.mailbox" "Trash" {
  stop;
}

pipe :copy "rspamc-wrapper" [ "learn_ham" ];
