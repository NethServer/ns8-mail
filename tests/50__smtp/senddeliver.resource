*** Settings ***
Library    SSHLibrary
Library    String
Library    Collections
Resource    ../api.resource
Resource    ../keywords.resource

*** Variables ***
${U1CREDS}    u1:Nethesis,1234
${U3CREDS}    u3:Nethesis,1234

*** Keywords ***
Raise Rspamd Thresholds
    Run task    module/${MID}/set-filter-configuration    {"antispam":{"enabled":true,"spam_flag_threshold":15.0,"deny_message_threshold":20.0}}

Reset Rspamd Thresholds
    Run task    module/${MID}/set-filter-configuration    {"antispam":{"enabled":true,"spam_flag_threshold":6.0,"deny_message_threshold":15.0}}

Should be user unknown
    [Arguments]    ${from}    ${to}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    MAIL_SERVER=${MAIL_SERVER} bash /tmp/test-mta.sh ${to} ${from}
    ...    return_rc=True    return_stderr=True
    Should Contain    ${err}    550 5.1.1 <${to}>: Recipient address rejected: User unknown in virtual alias table

Should be relay access denied
    [Arguments]    ${from}    ${to}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    MAIL_SERVER=${MAIL_SERVER} bash /tmp/test-mta.sh ${to} ${from}
    ...    return_rc=True    return_stderr=True
    Should Contain    ${err}    554 5.7.1 <${to}>: Relay access denied

Send message MTA
    [Arguments]    ${from}    ${to}    ${rc_expected}=0
    ${out}  ${err}  ${rc} =    Execute Command
    ...    MAIL_SERVER=${MAIL_SERVER} bash /tmp/test-mta.sh ${to} ${from}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  ${rc_expected}  Unexpected exit code ${rc}: out=${out} err=${err}
    ${queue_id}=    Get Queue ID From Output    ${err}
    Log    Queue ID: ${queue_id}
    RETURN    ${queue_id}

Get Queue ID From Output
    [Arguments]    ${text}
    ${group_matches}=    Get Regexp Matches    ${text}    queued as (\\w+)    1
    Should Not Be Empty    ${group_matches}    Queue ID not found in output
    ${queue_id}=       Get From List    ${group_matches}    0
    RETURN    ${queue_id}

Send message as MTA and check delivery
    [Arguments]    ${from}    ${to}    ${imap_folder}=INBOX    @{delivery_args}
    ${queue_id}=    Send message MTA    ${from}    ${to}
    ${count_delivery_checks}=    Get Length    ${delivery_args}
    FOR    ${counter}    IN RANGE    0    ${count_delivery_checks}    2
        ${credentials}=        Get From List    ${delivery_args}    ${counter}
        ${delivery_status}=    Get From List    ${delivery_args}    ${counter + 1}
        Check delivery    ${queue_id}    ${imap_folder}    ${credentials}    ${delivery_status}
    END

Check delivery
    [Arguments]    ${queue_id}    ${imap_folder}    ${credentials}    ${delivery_status}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    curl -u '${credentials}' -v -X 'SEARCH HEADER Received ${queue_id}' imap://127.0.0.1/${imap_folder}
    ...    return_rc=True    return_stderr=True
    ${matches}=    Get Regexp Matches    ${out}    ^\\* SEARCH \\d+
    IF    $delivery_status == "delivered"
        Should Not Be Empty    ${matches}    Message queue ID ${queue_id} not found in ${imap_folder}
    ELSE
        Should Be Empty        ${matches}    Message queue ID found ${queue_id} in ${imap_folder}
    END

Assign public IP address
    ${out}=    Execute Command    bash -c "ip -o route get 255.0 2>/dev/null | sed -e 's/.*src \\([^ ]*\\) .*/\\1/'"
    Set Global Variable    $MAIL_SERVER    ${out}

Create mail domains
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-users.test","addusers":true,"addgroups":false}
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-groups.test","addusers":false,"addgroups":true}
    Run task     module/${MID}/add-domain
    ...            {"domain":"mta-ug.test","addusers":true,"addgroups":true,"catchall":{"dtype":"user","name":"ucatchall"}}

Destroy mail domains
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-users.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-groups.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"mta-ug.test"}
Switch user domain
    [Arguments]     ${udom}
    Run task     module/${MID}/configure-module
    ...          {"hostname":"mail.domain.test","user_domain":"${udom}","mail_domain":"domain.test"}

Create mail aliases
    Run task    module/${MID}/add-address    {"atype":"domain","local":"a1","domain":"mta-ug.test","destinations":[{"dtype":"user","name":"u1"}]}
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"a2","destinations":[{"dtype":"user","name":"u1"},{"dtype":"group","name":"g2"}]}

Destroy mail aliases
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"a1","domain":"mta-ug.test"}
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"a2"}
