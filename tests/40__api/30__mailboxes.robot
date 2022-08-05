*** Settings ***
Resource    ../api.resource
Resource    ../user_domain.resource
Library    Collections

*** Test Cases ***
Check user mailboxes are available
    ${jpayload} =    Run task    module/${MID}/list-user-mailboxes    ""    decode_json=${FALSE}
    Should Contain    ${jpayload}    "u1"
    Should Contain    ${jpayload}    "u2"
    Should Contain    ${jpayload}    "u3"
    Should Contain    ${jpayload}    "admin"
    Should Not Contain    ${jpayload}    "vmail"

Change user mailbox attributes
    Run task    module/${MID}/alter-user-mailbox    {"user":"u1","forward":{"destinations":[{"dtype":"user","name":"admin"}]},"quota":{"limit":31},"spam_retention":{"value":7,"custom":true}}

Check user mailbox attibute changes were applied
    ${lmailboxes} =    Run task    module/${MID}/list-user-mailboxes    ""
    FOR  ${ombx}    IN    @{lmailboxes}[user_mailboxes]
        IF    "${ombx}[user]" == "u1"
            Should Be Equal    ${ombx}[forward][destinations][0][name]    admin
            Should Be Equal As Integers    ${ombx}[quota][limit]    31
            Should Be Equal As Integers    ${ombx}[spam_retention][value]    7
        ELSE
            Should Be Equal As Integers    ${ombx}[quota][limit]    0
        END
    END

Disable user mailbox
    Run task    module/${MID}/set-mailbox-enabled    {"user":"u1","enabled":false}

Check the mailbox is disabled
    ${lmailboxes} =    Run task    module/${MID}/list-user-mailboxes    ""
    FOR  ${ombx}    IN    @{lmailboxes}[user_mailboxes]
        IF    "${ombx}[user]" == "u1"
            Should Be Equal    ${ombx}[enabled]    ${FALSE}
        ELSE
            Should Be Equal As Integers    ${ombx}[quota][limit]    0
        END
    END

Check the user SMTP login fails
    Run Keyword And Expect Error    67 !\= 0    SMTP AUTH submissions good login

Check the user IMAP login fails
    Run Keyword And Expect Error    67 !\= 0    IMAP login good credentials

Enable user mailbox
    Run task    module/${MID}/set-mailbox-enabled    {"user":"u1","enabled":true}

Check the user SMTP login succeedes
    Run Keyword    SMTP AUTH submissions good login

Check the user IMAP login succeedes
    Run Keyword    IMAP login good credentials

Check the postmaster public mailbox is present
    ${lmailboxes} =   Run task    module/${MID}/list-public-mailboxes    ""
    ${expected} =    Evaluate    json.loads('''[{"mailbox": "postmaster", "acls": []}]''')
    Should Be Equal    ${lmailboxes}    ${expected}

Add a public employees mailbox
    Run task    module/${MID}/add-public-mailbox    {"mailbox":"employees", "acls": [{"stype":"user","subject":{"name":"u1","dtype":"user"},"rights":{"rtype":"full"}},{"stype":"group","subject":{"name":"domain admins","dtype":"group"},"rights":{"rtype":"rw"}},{"stype":"user","subject":{"name":"u2","dtype":"user"},"rights":{"rtype":"ro"}}]}

Check the public mailbox employees is properly configured
    ${lmailboxes} =    Run task    module/${MID}/list-public-mailboxes    ""
    FOR  ${ombx}    IN    @{lmailboxes}
        IF    "${ombx}[mailbox]" == "employees"
            Length Should Be    ${ombx}[acls]    3
        END
    END

Alter public mailbox acls
    Run task    module/${MID}/alter-public-mailbox    {"mailbox":"employees", "acls": [{"stype":"user","subject":{"name":"u1","dtype":"user"},"rights":{"rtype":"full"}},{"stype":"user","subject":{"name":"u2","dtype":"user"},"rights":{"rtype":"ro"}}]}

Check the ACL was removed from public mailbox employees
    ${lmailboxes} =    Run task    module/${MID}/list-public-mailboxes    ""
    FOR  ${ombx}    IN    @{lmailboxes}
        IF    "${ombx}[mailbox]" == "employees"
            Length Should Be    ${ombx}[acls]    2
        END
    END

Remove the public mailbox employees
    Run task    module/${MID}/remove-public-mailbox    {"mailbox":"employees"}
    ${lmailboxes} =   Run task    module/${MID}/list-public-mailboxes    ""
    ${expected} =    Evaluate    json.loads('''[{"mailbox": "postmaster", "acls": []}]''')
    Should Be Equal    ${lmailboxes}    ${expected}
