*** Settings ***
Library    SSHLibrary

*** Keywords ***
Retry test
    [Arguments]    ${keyword}
    Wait Until Keyword Succeeds    20 seconds    0.5 seconds    ${keyword}

TCP port is open
    [Arguments]    ${port}
    ${out}  ${err}  ${rc} =    Execute Command
    ...    exec 3<>/dev/tcp/127.0.0.1/${port}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0

Retry until TCP port is open
    [Arguments]    ${port}
    Wait Until Keyword Succeeds    10 seconds    0.2 seconds
    ...    TCP port is open    ${port}
