*** Settings ***
Resource    ../api.resource
Library    Collections

*** Variables ***
${test_domain}    api-owned.test
${owner}    00000000-test-owner
${other}    00000000-other-owner

*** Test Cases ***
Create domain ${test_domain} with users
    Run task    module/${MID}/add-domain    {"domain":"${test_domain}","addusers":true,"addgroups":true}

Add owned addresses
    ${out} =    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"mylist","destination":"mylist@sympa1.invalid"},{"local":"mylist-request","destination":"mylist-request@sympa1.invalid"}]}
    Length Should Be    ${out}[created]    2

Adding the same owned addresses again changes nothing
    ${out} =    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"mylist","destination":"mylist@sympa1.invalid"}]}
    Length Should Be    ${out}[created]    0

Another owner cannot take an owned address
    Run task    module/${MID}/add-owned-addresses    {"owner":"${other}","domain":"${test_domain}","addresses":[{"local":"mylist","destination":"mylist@sympa1.invalid"}]}
    ...    rc_expected=10

A user name cannot become an owned address
    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"u1","destination":"u1@sympa1.invalid"}]}
    ...    rc_expected=10

A wildcard address cannot become an owned address
    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"postmaster","destination":"pm@sympa1.invalid"}]}
    ...    rc_expected=10

A failed request creates nothing
    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"newlist","destination":"newlist@sympa1.invalid"},{"local":"u1","destination":"u1@sympa1.invalid"}]}
    ...    rc_expected=10
    ${out} =    Run task    module/${MID}/list-owned-addresses    {"owner":"${owner}"}
    FOR    ${addr}    IN    @{out}[addresses]
        Should Not Be Equal    ${addr}[local]    newlist
    END

A hand-made address with the same destination is taken over
    Run task    module/${MID}/add-address    {"atype":"domain","domain":"${test_domain}","local":"handmade","destinations":[{"dtype":"external","name":"handmade@sympa1.invalid"}]}
    ${out} =    Run task    module/${MID}/add-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","addresses":[{"local":"handmade","destination":"handmade@sympa1.invalid"}]}
    Should Be Equal    ${out}[created]    ${{["handmade"]}}

An owner removes only its addresses
    Run task    module/${MID}/add-address    {"atype":"domain","domain":"${test_domain}","local":"notmine","destinations":[{"dtype":"external","name":"notmine@example.invalid"}]}
    ${out} =    Run task    module/${MID}/remove-owned-addresses    {"owner":"${other}","domain":"${test_domain}"}
    Length Should Be    ${out}[removed]    0
    ${out} =    Run task    module/${MID}/remove-owned-addresses    {"owner":"${owner}","domain":"${test_domain}","locals":["mylist"]}
    Length Should Be    ${out}[removed]    1

Removing an address also removes its ownership
    Run task    module/${MID}/remove-address    {"atype":"domain","domain":"${test_domain}","local":"handmade"}
    ${out} =    Run task    module/${MID}/list-owned-addresses    {"owner":"${owner}"}
    Length Should Be    ${out}[addresses]    1

Remove all addresses of an owner
    ${out} =    Run task    module/${MID}/remove-owned-addresses    {"owner":"${owner}"}
    Length Should Be    ${out}[removed]    1
    ${out} =    Run task    module/${MID}/list-owned-addresses    {"owner":"${owner}"}
    Length Should Be    ${out}[addresses]    0

Remove domain ${test_domain}
    Run task    module/${MID}/remove-domain    {"domain":"${test_domain}"}
