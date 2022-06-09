*** Settings ***
Resource    api.resource
Library    SSHLibrary

*** Variables ***
${user_domain_ad}        ad.dom.test
${user_domain_ldap}      ldap.dom.test

*** Test Cases ***
Mail module installation
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Global Variable    ${MID}    ${output.module_id}

Get defaults
    ${hostname} =    Execute Command    hostname -f
    ${response} =    Run task     module/${MID}/get-defaults    {}

    Should Contain    ${response['user_domains']}    ${user_domain_ad}
    Should Contain    ${response['user_domains']}    ${user_domain_ldap}
    Should Be Equal   ${response['hostname']}        ${hostname}
