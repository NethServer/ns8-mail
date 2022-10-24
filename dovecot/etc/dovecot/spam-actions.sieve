#
# Actions to run if header X-Spam is set
#

require [
    "editheader",
    "vnd.dovecot.environment",
    "variables",
    "fileinto",
    "mailbox"
];

if header :matches "Subject" "*" {
    set "origsubject" "${1}";
}

if allof (
            header :is "X-Spam" "Yes",
            not string :is "${env.vnd.dovecot.config.spam_subject_prefix}" ""
         )
{
    deleteheader "Subject";
    addheader "Subject" "${env.vnd.dovecot.config.spam_subject_prefix} ${origsubject}";
    addheader "X-Orig-Subject" "${origsubject}";
    set "stopfilter" "1";
}

if allof (
            header :is "X-Spam" "Yes",
            string :is "${env.vnd.dovecot.config.spam_folder_auto}" "subscribe"
         )
{
    fileinto :create "${env.vnd.dovecot.config.spam_folder}";
    set "stopfilter" "1";
}

if string :is "${stopfilter}" "1" {
    stop;
}
