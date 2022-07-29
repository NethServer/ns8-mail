*** Settings ***
Resource    api.resource
Library    SSHLibrary
Resource    ldap_providers.resource

*** Variables ***
${MID}

*** Test Cases ***
Mail module removal
    ${rc} =    Execute Command    remove-module --no-preserve ${MID}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Remove account providers
    [Tags]    udom    remove
    Remove AD user domain
    Remove LDAP user domain
