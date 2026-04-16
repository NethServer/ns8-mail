*** Settings ***
Resource    keywords.resource

*** Test Cases ***

Ping clamd
    ${out}  ${err}  ${rc} =    Execute Command
    ...    ( exec <>/dev/tcp/127.0.0.1/11330 1>&0 ; echo PING ; read resp ; test \${resp} \= PONG )
    ...    return_rc=True    return_stderr=True    timeout=1s
    Should Be Equal As Integers    ${rc}    0
