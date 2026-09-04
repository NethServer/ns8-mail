*** Settings ***
Resource    ../api.resource
Library    Collections

*** Variables ***
${test_domain}    api-addresses.test
${addalias_domain}    api-addalias.test

*** Test Cases ***
Create domain ${test_domain} with users and groups
    Run task    module/${MID}/add-domain    {"domain":"${test_domain}","addusers":true,"addgroups":true}

Check users and groups addresses are in the address list
    ${ou1} =    Evaluate    {"atype": "adduser","local": "u1","description": "First User"}
    ${og1} =    Evaluate    {"atype": "addgroup","local": "g1","description": "Group One"}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    Should Contain    ${laddresses}[addresses]    ${ou1}
    Should Contain    ${laddresses}[addresses]    ${og1}

Check mixed-case AD/LDAP user and group destinations are lower-cased
    ${ldest} =    Run task    module/${MID}/list-destinations    ""
    ${user_found} =    Set Variable    ${FALSE}
    ${group_found} =    Set Variable    ${FALSE}
    FOR    ${odest}    IN    @{ldest}
        IF    "${odest}[dtype]" == "user" and "${odest.get('ui_name', '')}" == "Mixed Case User"
            Should Be Equal    ${odest}[name]    mixedcaseuser
            ${user_found} =    Set Variable    ${TRUE}
        END
        IF    "${odest}[dtype]" == "group" and "${odest.get('ui_name', '')}" == "Mixed Case Group"
            Should Be Equal    ${odest}[name]    mixedcasegroup
            ${group_found} =    Set Variable    ${TRUE}
        END
    END
    Should Be True    ${user_found}
    Should Be True    ${group_found}

Add a user address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"u1-alias","domain":"${test_domain}","destinations":[{"dtype":"user","name":"u1"}]}

Add invalid address
    Run task    module/${MID}/add-address    {"atype":"domain","local":"u1 alias","domain":"${test_domain}","destinations":[{"dtype":"user","name":"u1"}]}
    ...    rc_expected=10

Add a group address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"g1-alias","domain":"${test_domain}","destinations":[{"dtype":"group","name":"g1"}]}

Add a mixed-case user address alias
    Run task    module/${MID}/add-address    {"atype":"domain","local":"mixeduser-alias","domain":"${test_domain}","destinations":[{"dtype":"user","name":"MixedCaseUser"}]}

Check the mixed-case user destination matches list-destinations
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    ${ldest} =    Run task    module/${MID}/list-destinations    ""
    ${alias_dest_name} =    Set Variable    ${NONE}
    FOR    ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "mixeduser-alias"
            FOR    ${odest}    IN    @{oaddr}[destinations]
                ${alias_dest_name} =    Set Variable    ${odest}[name]
            END
        END
    END
    Should Be Equal    ${alias_dest_name}    mixedcaseuser
    ${dest_match_found} =    Set Variable    ${FALSE}
    FOR    ${odest}    IN    @{ldest}
        IF    "${odest}[dtype]" == "user" and "${odest}[name]" == "${alias_dest_name}"
            ${dest_match_found} =    Set Variable    ${TRUE}
        END
    END
    Should Be True    ${dest_match_found}

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

Create domain ${addalias_domain} with addaliases flag
    Initialize AD reference
    Run task    module/${MID}/add-domain    {"domain":"${addalias_domain}","addaliases":true}

Set u3 LDAP mail attribute to test the addalias address
    Run task    module/${mid_ad}/alter-user    {"user":"u3","mail":"apialias@${addalias_domain}"}

Check the addalias address is in the address list
    ${oalias} =    Evaluate
    ...    {"atype":"addalias","local":"apialias","domain":"${addalias_domain}","destinations":[{"dtype":"user","name":"u3","ui_name":"Third User"}]}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    Should Contain    ${laddresses}[addresses]    ${oalias}
    Should Contain    ${laddresses}[addalias_domains]    ${addalias_domain}

Set u1 LDAP mail attribute to the same address as u3
    Run task    module/${mid_ad}/alter-user    {"user":"u1","mail":"apialias@${addalias_domain}"}

Check the addalias address merges every user sharing the same mail attribute
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    ${u1_found} =    Set Variable    ${FALSE}
    ${u3_found} =    Set Variable    ${FALSE}
    FOR    ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[atype]" == "addalias" and "${oaddr}[local]" == "apialias"
            Length Should Be    ${oaddr}[destinations]    2
            FOR    ${odest}    IN    @{oaddr}[destinations]
                IF    "${odest}[name]" == "u1"
                    ${u1_found} =    Set Variable    ${TRUE}
                END
                IF    "${odest}[name]" == "u3"
                    ${u3_found} =    Set Variable    ${TRUE}
                END
            END
        END
    END
    Should Be True    ${u1_found}
    Should Be True    ${u3_found}

Add an exact-domain SQLite alias for the same address
    Run task    module/${MID}/add-address
    ...    {"atype":"domain","local":"apialias","domain":"${addalias_domain}","destinations":[{"dtype":"user","name":"u2"}]}

Check the exact-domain alias takes priority over the addalias one
    ${otarget} =    Evaluate
    ...    {"atype":"domain","local":"apialias","domain":"${addalias_domain}","destinations":[{"dtype":"user","name":"u2","ui_name":"Second User"}]}
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    ${found} =    Set Variable    ${FALSE}
    FOR    ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "apialias" and "${oaddr.get('domain', '')}" == "${addalias_domain}"
            Dictionaries Should Be Equal    ${oaddr}    ${otarget}
            ${found} =    Set Variable    ${TRUE}
        END
    END
    Should Be True    ${found}

Remove the exact-domain alias
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"apialias","domain":"${addalias_domain}"}

Add a wildcard SQLite alias for the same local part
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"apialias","destinations":[{"dtype":"user","name":"u2"}]}

Check the wildcard alias takes priority over the addalias one
    ${laddresses} =    Run task    module/${MID}/list-addresses    ""
    ${addalias_found} =    Set Variable    ${FALSE}
    ${wildcard_found} =    Set Variable    ${FALSE}
    FOR    ${oaddr}    IN    @{laddresses}[addresses]
        IF    "${oaddr}[local]" == "apialias" and "${oaddr}[atype]" == "addalias"
            ${addalias_found} =    Set Variable    ${TRUE}
        END
        IF    "${oaddr}[local]" == "apialias" and "${oaddr}[atype]" == "wildcard"
            ${wildcard_found} =    Set Variable    ${TRUE}
        END
    END
    Should Not Be True    ${addalias_found}
    Should Be True    ${wildcard_found}

Remove the wildcard alias and reset LDAP mail attributes
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"apialias"}
    Run task    module/${mid_ad}/alter-user    {"user":"u1","mail":"ldapa1@inbound.test"}
    Run task    module/${mid_ad}/alter-user    {"user":"u3","mail":""}

Remove domain ${addalias_domain}
    Run task    module/${MID}/remove-domain    {"domain":"${addalias_domain}"}

*** Keywords ***
Initialize AD reference
    [Documentation]    This suite runs isolated from tests/ldap_providers.resource, and the AD user
    ...                domain is the one bound to ${MID} at this point in the test run (see "Switch
    ...                to AD user domain" in 20__dovecot.robot), so ${mid_ad} must be looked up here
    ...                via service discovery instead of relying on a cross-suite variable.
    ${out}  ${err}  ${rc} =    Execute Command
    ...    runagent python3 -c 'import agent ; print(agent.list_service_providers(agent.redis_connect(), "ldap", "tcp", filters={"domain":"ad.dom.test"})[0]["module_id"])'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    Failed to look up AD provider module_id: ${err}
    Should Not Be Empty    ${out}    AD provider module_id not found in service discovery
    Set Suite Variable    ${mid_ad}    ${out}
