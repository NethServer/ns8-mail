*** Settings ***
Library           SSHLibrary
Library           DateTime
Resource          setup.resource

*** Variables ***
${SSH_KEYFILE}    %{HOME}/.ssh/id_ecdsa
${NODE_ADDR}      127.0.0.1

*** Keywords ***
Connect to the node
    Open Connection   ${NODE_ADDR}
    Login With Public Key    root    ${SSH_KEYFILE}

Wait until boot completes
    ${output} =    Execute Command    systemctl is-system-running  --wait
    Should Be True    '${output}' == 'running' or '${output}' == 'degraded'

Save the journal begin timestamp
    ${tsnow} =    Get Current Date    result_format=epoch
    Set Global Variable    ${JOURNAL_SINCE}    ${tsnow}

Collect the suite journal
    Execute Command    journalctl -S @${JOURNAL_SINCE} >journal-dump.log
    Get File    journal-dump.log    ${OUTPUT DIR}/journal-${SUITE NAME}.log

*** Settings ***
Suite Setup       Run Keywords
                  ...    Connect to the Node
                  ...    Wait until boot completes
                  ...    Configure AD user domain
                  ...    Configure LDAP user domain
                  ...    Save the journal begin timestamp

Suite Teardown    Run Keywords
                  ...    Remove AD user domain
                  ...    Remove LDAP user domain
                  ...    Collect the suite journal
