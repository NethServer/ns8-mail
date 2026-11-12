*** Settings ***
Documentation    Postfix master.cf entries: the master.append entries
...              are appended to master.cf, and replace the entries with
...              the same service name and type.
Resource    ../api.resource
Resource    ../keywords.resource
Library     SSHLibrary
Library     String
Suite Teardown    Remove custom file

*** Variables ***
${cfdir}    /etc/postfix/main.cf.d

*** Test Cases ***
Entries replace and extend master.cf
    Write custom file    master.append    showq unix n - n - 5 showq\\n127.0.0.1:10026 inet n - n - - smtpd\\n -o syslog_name=postfix/test10026\\n
    Reload Postfix
    # Both showq entries are listed: Postfix uses the last one
    ${out} =    Postfix    postconf -h -F showq/unix/process_limit
    ${lines} =    Split To Lines    ${out}
    Should Be Equal    ${lines}[-1]    5
    ${out} =    Postfix    postconf -Mf 127.0.0.1:10026/inet
    Should Contain    ${out}    syslog_name=postfix/test10026
    Retry until TCP port is open    10026

The file is not appended to main.cf
    ${out} =    Postfix    grep -c showq /etc/postfix/main.cf    rc_expected=1
    Should Be Equal    ${out.strip()}    0

The entries are counted by facts
    ${facts} =    Run task    module/${MID}/get-facts    ""
    Should Be Equal As Integers    ${facts}[postfix_master_custom_count]    2

Removing the file restores master.cf
    Remove custom file
    ${out} =    Postfix    postconf -M
    Should Not Contain    ${out}    127.0.0.1:10026
    ${out} =    Postfix    postconf -h -F showq/unix/process_limit
    Should Be Equal    ${out.strip()}    -

*** Keywords ***
Postfix
    [Arguments]    ${command}    ${rc_expected}=0
    [Documentation]    Run a command in the postfix container
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent -m ${MID} podman exec postfix ${command}
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    ${rc_expected}    ${command} failed:${\n}${err}
    RETURN    ${out}

Write custom file
    [Arguments]    ${name}    ${content}
    Execute Command    printf '${content}' | runagent -m ${MID} podman exec -i postfix sh -c 'cat > ${cfdir}/${name}'

Remove custom file
    Postfix    rm -f ${cfdir}/master.append
    Reload Postfix

Reload Postfix
    ${out}  ${err}  ${rc} =    Execute Command    runagent -m ${MID} systemctl --user reload postfix
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    reload failed:${\n}${err}
