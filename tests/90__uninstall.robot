*** Settings ***
Resource    api.resource
Library    SSHLibrary

*** Variables ***
${MID}

*** Test Cases ***
Mail module removal
    ${rc} =    Execute Command    remove-module --no-preserve ${MID}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
