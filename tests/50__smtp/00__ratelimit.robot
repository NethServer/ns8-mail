*** Settings ***
Documentation    Rate limit of messages sent by authenticated users.
...              Messages are sent through SMTP: Rspamd skips the
...              rate limit for requests from rspamc.
Resource    smtp.resource
Suite Setup        Enable rate limit
Suite Teardown     Disable rate limit
Test Tags    ratelimit

*** Variables ***
# 12 messages per hour, burst of 1 message
${rl_hourly}         12
# 36 messages per hour, burst of 3 messages
${rl_bulk_hourly}    36
${rl_error}          451 4.7.1 Sending rate limit exceeded, try again later

*** Test Cases ***
User is limited after the burst
    Send SMTP message to  u1@inbound.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be delivered via LMTP to  u1
    Send SMTP message to  u1@inbound.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    ...                   expect_curl_exitcode=
    Should return SMTP error    ${rl_error}

Bulk user has a higher limit
    FOR    ${i}    IN RANGE    3
        Send SMTP message to  u1@inbound.test
        ...                   from=u2@inbound.test
        ...                   credentials=u2:LdapPass,1234
    END
    Send SMTP message to  u1@inbound.test
    ...                   from=u2@inbound.test
    ...                   credentials=u2:LdapPass,1234
    ...                   expect_curl_exitcode=
    Should return SMTP error    ${rl_error}

Exempt user is never limited
    FOR    ${i}    IN RANGE    5
        Send SMTP message to  u1@inbound.test
        ...                   from=u3@inbound.test
        ...                   credentials=u3:Nethesis,1234
    END

Unauthenticated messages are not limited
    FOR    ${i}    IN RANGE    3
        Send SMTP message to  u1@inbound.test
        Should be delivered via LMTP to  u1
    END

Limit is off when the variable is removed
    Disable rate limit
    Send SMTP message to  u1@inbound.test
    ...                   from=u1@inbound.test
    ...                   credentials=u1:Nethesis,1234
    Should be delivered via LMTP to  u1

*** Keywords ***
Enable rate limit
    Execute Command    runagent -m ${MID} podman exec rspamd sh -c 'echo u2 > /var/lib/rspamd/ratelimit_bulk.map && echo u3 > /var/lib/rspamd/ratelimit_exempt.map'
    Execute Command    runagent -m ${MID} sh -c 'sed -i "/^RSPAMD_RL_/d" rspamd.env && printf "RSPAMD_RL_HOURLY=${rl_hourly}\\nRSPAMD_RL_BULK_HOURLY=${rl_bulk_hourly}\\n" >> rspamd.env'
    Reload Rspamd and wait for    enabled ratelimit: user

Disable rate limit
    Execute Command    runagent -m ${MID} sh -c 'sed -i "/^RSPAMD_RL_/d" rspamd.env'
    Execute Command    runagent -m ${MID} podman exec rspamd sh -c 'echo > /var/lib/rspamd/ratelimit_bulk.map && echo > /var/lib/rspamd/ratelimit_exempt.map'
    Reload Rspamd and wait for    init lua module ratelimit

Reload Rspamd and wait for
    [Documentation]    Reload Rspamd and wait until the new configuration
    ...                is loaded, matching ${pattern} in the journal
    [Arguments]    ${pattern}
    ${since} =    Get Current Date
    ${out}  ${rc} =    Execute Command    runagent -m ${MID} systemctl --user reload rspamd    return_rc=True
    Should Be Equal As Integers    ${rc}    0    Rspamd reload failed: ${out}
    Wait Until Keyword Succeeds    20    1s
    ...    Journal should contain    ${since}    ${pattern}
    # Let the new worker processes start
    Sleep    2s

Journal should contain
    [Arguments]    ${since}    ${pattern}
    ${out} =    Execute Command    journalctl -o cat -S '${since}' -g '${pattern}'
    Should Not Be Empty    ${out}    Pattern `${pattern}` not found in journal since ${since}
