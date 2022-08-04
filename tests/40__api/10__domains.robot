*** Settings ***
Resource    ../api.resource

*** Variables ***
${test_domain}    api-domains.test

*** Test Cases ***
Create ${test_domain} domain
    Run task    module/${MID}/add-domain    {"domain":"${test_domain}"}

Check ${test_domain} is in the domain list
    ${jpayload} =    Run task    module/${MID}/list-domains    ""    decode_json=${FALSE}
    Should Contain    ${jpayload}    "${test_domain}"

Change ${test_domain} properties
    Run task    module/${MID}/alter-domain    {"domain":"${test_domain}","addusers":false,"addgroups":true,"catchall":{"dtype":"user","name":"u1"},"bccaddr":"spy@example.invalid","description":"My test case"}

Check ${test_domain} properties are in the domain list
    @{ldom} =    Run task    module/${MID}/list-domains    ""
    FOR  ${odom}    IN    @{ldom}
        IF    "${odom}[domain]" == "${test_domain}"
            Should Be Equal    ${odom}[addusers]    ${FALSE}
            Should Be Equal    ${odom}[addgroups]    ${TRUE}
            Should Be Equal    ${odom}[catchall][name]    u1
            Should Be Equal    ${odom}[bccaddr]    spy@example.invalid
            Should Be Equal    ${odom}[description]    My test case
        END
    END

Remove ${test_domain} domain
    Run task    module/${MID}/remove-domain    {"domain":"${test_domain}"}

Check ${test_domain} is no longer in the domain list
    ${jpayload} =    Run task    module/${MID}/list-domains    ""    decode_json=${FALSE}
    Should Not Contain    ${jpayload}    "${test_domain}"
