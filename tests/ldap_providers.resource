*** Settings ***
Resource    api.resource

*** Variables ***
${user_domain_ad}        ad.dom.test
${user_domain_ldap}      ldap.dom.test

*** Keywords ***
Configure AD user domain
    [Tags]    udom    add    ad
    ${response} =     Run task    cluster/add-internal-provider    {"image":"samba","node":1}
    Set Suite Variable    ${mid_ad}    ${response['module_id']}
    ${response} =    Run task    module/${mid_ad}/get-defaults    {"provision":"new-domain"}
    ${ad_ipaddress} =    Set Variable    ${response['ipaddress_list'][0]['ipaddress']}
    Should Not Be Empty    ${ad_ipaddress}
    ${ad_nbdomain} =    Set Variable    ${response['nbdomain']}
    ${ad_hostname} =    Set Variable    ${response['hostname']}
    Run task    module/${mid_ad}/configure-module    {"realm":"${user_domain_ad}","hostname":"${ad_hostname}","nbdomain":"${ad_nbdomain}","ipaddress":"${ad_ipaddress}","adminuser":"administrator","adminpass":"Nethesis,1234","provision":"new-domain"}
    Run task    module/${mid_ad}/add-user    {"user":"u1","display_name":"First User","password":"Nethesis,1234"}
    Run task    module/${mid_ad}/add-user    {"user":"u2","display_name":"Second User","password":"AdPass,1234"}
    Run task    module/${mid_ad}/add-user    {"user":"u3","display_name":"Third User","password":"Nethesis,1234"}
    Run task    module/${mid_ad}/add-group   {"group":"g1","description":"Group One","users":["u1","u2"]}
    Run task    module/${mid_ad}/add-group   {"group":"g2","description":"Group Two","users":["u2","u3"]}
    Run task    module/${mid_ad}/add-user    {"user":"ucatchall","display_name":"Catch All User","password":"Nethesis,1234"}

Configure LDAP user domain
    [Tags]    udom    add    ldap
    ${response} =     Run task    cluster/add-internal-provider    {"image":"openldap","node":1}
    Set Suite Variable    ${mid_ldap}    ${response['module_id']}
    Run task    module/${mid_ldap}/configure-module    {"domain":"${user_domain_ldap}","admuser":"admin","admpass":"Nethesis,1234","provision":"new-domain"}
    Run task    module/${mid_ldap}/add-user    {"user":"u1","display_name":"First User","password":"Nethesis,1234"}
    Run task    module/${mid_ldap}/add-user    {"user":"u2","display_name":"Second User","password":"LdapPass,1234"}
    Run task    module/${mid_ldap}/add-user    {"user":"u3","display_name":"Third User","password":"Nethesis,1234"}
    Run task    module/${mid_ldap}/add-group   {"group":"g1","description":"Group One","users":["u1","u2"]}
    Run task    module/${mid_ldap}/add-group   {"group":"g2","description":"Group Two","users":["u2","u3"]}
    Run task    module/${mid_ldap}/add-user    {"user":"ucatchall","display_name":"Catch All User","password":"Nethesis,1234"}

Remove AD user domain
    [Tags]    udom    remove    ad
    Run task    cluster/remove-internal-domain    {"domain":"${user_domain_ad}"}

Remove LDAP user domain
    [Tags]    udom    remove    ldap
    Run task    cluster/remove-internal-domain    {"domain":"${user_domain_ldap}"}
