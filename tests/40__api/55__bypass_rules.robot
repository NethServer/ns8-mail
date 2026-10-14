*** Settings ***
Resource    ../api.resource
Suite Setup       Setup bypass and block rules
Suite Teardown    Cleanup bypass and block rules

*** Variables ***
${RELAY}    bounce@relay.example.net
${OTHER}    info@other.example.net

*** Keywords ***
Setup bypass and block rules
    Run task    module/${MID}/add-bypass-rule    {"type":"domain","direction":"from","value":"bypass.test"}    decode_json=${FALSE}
    Run task    module/${MID}/add-bypass-rule    {"type":"email","direction":"from","value":"news@bypass2.test"}    decode_json=${FALSE}
    Write block maps    block.test    .suffix.test    spammer@blocked.test

Cleanup bypass and block rules
    Run task    module/${MID}/remove-bypass-rule    {"type":"domain","direction":"from","value":"bypass.test"}    decode_json=${FALSE}
    Run task    module/${MID}/remove-bypass-rule    {"type":"email","direction":"from","value":"news@bypass2.test"}    decode_json=${FALSE}
    Write block maps    ${EMPTY}    ${EMPTY}    ${EMPTY}

Write block maps
    [Arguments]    ${domain}    ${suffix}    ${sender}
    ${out}    ${err}    ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec rspamd sh -c 'cd /var/lib/rspamd && echo "${domain}" > block_sender_domain.map && echo "${suffix}" > block_sender_domain_suffix.map && echo "${sender}" > block_sender.map && reload-config'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    Block maps update failed: ${err}

Scan message
    [Arguments]    ${envelope_from}    ${header_from}
    ${out}    ${err}    ${rc} =    Execute Command
    ...    printf '%s\\n' 'From: ${header_from}' 'To: <user@domain.test>' 'Subject: Sender rules test' '' 'Test message' | runagent -m ${MID} podman exec -i rspamd sh -c 'rspamc -h 127.0.0.1:11333 -P "$RSPAMD_adminpw" -F ${envelope_from} -i 192.0.2.10 symbols'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    rspamc failed: ${err}
    RETURN    ${out}

Scan result should contain
    [Arguments]    ${envelope_from}    ${header_from}    ${symbol}
    ${out} =    Scan message    ${envelope_from}    ${header_from}
    Should Contain    ${out}    Symbol: ${symbol} (

Scan result should not contain
    [Arguments]    ${envelope_from}    ${header_from}    ${symbol}
    ${out} =    Scan message    ${envelope_from}    ${header_from}
    Should Not Contain    ${out}    Symbol: ${symbol}

*** Test Cases ***
Bypass sender rules match the MIME From header too
    ${out}    ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec rspamd grep -c 'extract_from = "both"' /etc/rspamd/local.d/multimap.conf
    ...    return_rc=True
    Should Be Equal As Integers    ${out}    2

Bypass domain in header From with angle brackets
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    ${RELAY}    <info@bypass.test>    BYPASS_SENDER_DOMAIN

Bypass domain in header From with display name
    Scan result should contain    ${RELAY}    "Bypass Test" <info@bypass.test>    BYPASS_SENDER_DOMAIN

Bypass domain in header From with bare address
    Scan result should contain    ${RELAY}    info@bypass.test    BYPASS_SENDER_DOMAIN

Bypass domain in envelope sender
    Scan result should contain    info@bypass.test    <${OTHER}>    BYPASS_SENDER_DOMAIN

Bypass address in header From
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    ${RELAY}    <news@bypass2.test>    BYPASS_SENDER

Bypass address in envelope sender
    Scan result should contain    news@bypass2.test    <${OTHER}>    BYPASS_SENDER

Sender not in bypass maps
    Scan result should not contain    ${RELAY}    <${OTHER}>    BYPASS_

Block domain matches the envelope sender only
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    x@block.test    <${OTHER}>    BLOCK_SENDER_DOMAIN
    Scan result should not contain    ${RELAY}    <x@block.test>    BLOCK_SENDER_DOMAIN

Block domain suffix matches the envelope sender only
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    x@mail.suffix.test    <${OTHER}>    BLOCK_SENDER_DOMAIN_SUFFIX
    Scan result should not contain    ${RELAY}    <x@mail.suffix.test>    BLOCK_SENDER_DOMAIN_SUFFIX

Block address matches the envelope sender only
    Wait Until Keyword Succeeds    10 times    1s
    ...    Scan result should contain    spammer@blocked.test    <${OTHER}>    BLOCK_SENDER
    Scan result should not contain    ${RELAY}    <spammer@blocked.test>    BLOCK_SENDER (
