*** Settings ***
Library           SSHLibrary
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

*** Settings ***
Suite Setup       Run Keywords
                  ...    Connect to the Node
                  ...    Wait until boot completes
                  ...    Configure AD user domain
                  ...    Configure LDAP user domain

Suite Teardown    Run Keywords
                  ...    Remove AD user domain
                  ...    Remove LDAP user domain
