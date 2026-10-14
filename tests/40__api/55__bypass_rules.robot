*** Settings ***
Resource    ../api.resource
Suite Setup       Setup bypass and block rules
Suite Teardown    Cleanup bypass and block rules

*** Keywords ***
Setup bypass and block rules
    Run task    module/${MID}/add-bypass-rule    {"type":"domain","direction":"from","value":"bypass.test"}    decode_json=${FALSE}
    Run task    module/${MID}/add-bypass-rule    {"type":"email","direction":"from","value":"news@bypass2.test"}    decode_json=${FALSE}
    Execute Command    runagent -m ${MID} podman exec rspamd sh -c 'echo block.test > /var/lib/rspamd/block_sender_domain.map && reload-config'

Cleanup bypass and block rules
    Run task    module/${MID}/remove-bypass-rule    {"type":"domain","direction":"from","value":"bypass.test"}    decode_json=${FALSE}
    Run task    module/${MID}/remove-bypass-rule    {"type":"email","direction":"from","value":"news@bypass2.test"}    decode_json=${FALSE}
    Execute Command    runagent -m ${MID} podman exec rspamd sh -c 'echo "" > /var/lib/rspamd/block_sender_domain.map && reload-config'

Scan message
    [Arguments]    ${envelope_from}    ${header_from}
    ${out}    ${err}    ${rc} =    Execute Command
    ...    printf '%s\\n' 'From: <${header_from}>' 'To: <user@domain.test>' 'Subject: Bypass rule test' '' 'Test message' | runagent -m ${MID} podman exec -i rspamd sh -c 'rspamc -h 127.0.0.1:11333 -P "$RSPAMD_adminpw" -F ${envelope_from} -i 192.0.2.10 symbols'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    rspamc failed: ${err}
    RETURN    ${out}

Scan result should contain
    [Arguments]    ${envelope_from}    ${header_from}    ${symbol}
    ${out} =    Scan message    ${envelope_from}    ${header_from}
    Should Contain    ${out}    ${symbol}

Scan result should not contain
    [Arguments]    ${envelope_from}    ${header_from}    ${symbol}
    ${out} =    Scan message    ${envelope_from}    ${header_from}
    Should Not Contain    ${out}    ${symbol}

*** Test Cases ***
Bypass sender rules match the MIME From header too
    ${out}    ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec rspamd grep -c 'extract_from = "both"' /etc/rspamd/local.d/multimap.conf
    ...    return_rc=True
    Should Be Equal As Integers    ${out}    2

Header From domain in bypass map
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    bounce@relay.example.net    info@bypass.test    BYPASS_SENDER_DOMAIN

Header From address in bypass map
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    bounce@relay.example.net    news@bypass2.test    BYPASS_SENDER

Envelope sender domain in bypass map
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    info@bypass.test    info@other.example.net    BYPASS_SENDER_DOMAIN

Sender not in bypass map
    Scan result should not contain    bounce@relay.example.net    info@other.example.net    BYPASS_

Block rules ignore the MIME From header
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    x@block.test    info@other.example.net    BLOCK_SENDER_DOMAIN
    Scan result should not contain    bounce@relay.example.net    x@block.test    BLOCK_SENDER_DOMAIN
