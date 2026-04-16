*** Settings ***
Resource    keywords.resource

*** Test Cases ***

Ping rspamd
    ${out}  ${err}  ${rc} =    Execute Command
    ...    curl http://127.0.0.1:11334/ping
    ...    return_rc=True    return_stderr=True    timeout=5s
    Should Contain    ${out}    pong
