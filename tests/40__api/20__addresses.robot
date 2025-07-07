*** Settings ***
Resource    ../api.resource
Library    Collections

*** Variables ***
${test_domain}    api-addresses.test

*** Test Cases ***
Create domain ${test_domain} with users and groups
    Run task    module/${MID}/add-domain    {"domain":"${test_domain}","addusers":true,"addgroups":true}

Check users and groups addresses are in the address list
    ${ou1} =    Evaluate    {"atype": "adduser","local": "u1","description": "First User"}
    ${og1} =    Evaluate    {"atype": "addgroup","local": "g1","description": "Group One"}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    Should Contain    ${laddresses}[addresses]    ${ou1}
    Should Contain    ${laddresses}[addresses]    ${og1}

Add a user address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"u1-alias","domain":"${test_domain}","destinations":[{"dtype":"user","name":"u1"}]}

Add invalid address
    Run task    module/${MID}/add-address    {"atype":"domain","local":"u1 alias","domain":"${test_domain}","destinations":[{"dtype":"user","name":"u1"}]}
    ...    rc_expected=10

Add a group address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"g1-alias","domain":"${test_domain}","destinations":[{"dtype":"group","name":"g1"}]}

Add a public mailbox address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"mailadm","domain":"${test_domain}","destinations":[{"dtype":"public","name":"vmail+postmaster"}]}

Add an address for a distribution list
    Run task    module/${MID}/add-address    {"atype":"domain","local":"sales","domain":"${test_domain}","destinations":[{"dtype":"user","name":"u1"},{"dtype":"user","name":"u2"}]}

Check the distribution list is public
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    FOR  ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "sales"
            Dictionary Should Not Contain Key    ${oaddr}    internal
        END
    END

Set the distribution list internal
    Run task    module/${MID}/alter-address    {"atype":"domain", "local":"sales", "domain":"${test_domain}", "internal":true}

Check the distribution list is internal
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    FOR  ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "sales"
            Should Be Equal    ${oaddr}[internal]    ${TRUE}
        END
    END

Add a wildcard address alias
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"info","destinations":[{"dtype":"user","name":"u2"}]}

Remove domain ${test_domain}
    Run task    module/${MID}/remove-domain    {"domain":"${test_domain}"}

Check the addresses bound to ${test_domain} were removed
    ${ou1} =    Evaluate    {"atype": "adduser","local": "u1","description": "First User"}
    ${og1} =    Evaluate    {"atype": "addgroup","local": "g1","description": "Group One"}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    Should Contain    ${laddresses}[addresses]    ${ou1}
    Should Not Contain    ${laddresses}[addresses]    ${og1}
    Should Not Contain    ${laddresses}[adduser_domains]    ${test_domain}
    Should Not Contain    ${laddresses}[addgroup_domains]    ${test_domain}

Check the wildcard alias is still present
    ${otarget} =    Evaluate    {"atype":"wildcard","local":"info","destinations":[{"dtype":"user","name":"u2","ui_name":"Second User"}]}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    FOR  ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "info"
            Dictionaries Should Be Equal    ${oaddr}    ${otarget}
        END
    END

Remove the wildcard address
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"info"}
