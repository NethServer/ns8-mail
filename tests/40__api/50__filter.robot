*** Settings ***
Resource    ../api.resource
Resource    ../user_domain.resource
Library    Collections

*** Test Cases ***
Check default filter configuration
    ${dpayload} =    Run task    module/${MID}/get-filter-configuration    ""    decode_json=${TRUE}
    Should Be Equal As Numbers   ${dpayload}[antispam][spam_flag_threshold]    6.0
    Should Be Equal As Numbers   ${dpayload}[antispam][deny_message_threshold]    15.0
    Should Be Equal    ${dpayload}[antispam][greylist][enabled]    ${FALSE}
    Should Be Equal    ${dpayload}[antivirus][enabled]    ${TRUE}
    Should Be Equal    ${dpayload}[antivirus][clamav_official_sigs]    ${FALSE}
    Should Be Equal    ${dpayload}[antivirus][third_party_sigs_rating]    medium
    Should Be Equal As Integers   ${dpayload}[bypass_rules]    0

Change filter settings
    Run task    module/${MID}/set-filter-configuration    {"antivirus":{"enabled":false},"antispam":{"enabled":false}}
    Run task    module/${MID}/set-filter-configuration    {"antivirus":{"enabled":true,"clamav_official_sigs":true,"third_party_sigs_rating":"high"},"antispam":{"enabled":true,"greylist":{"enabled":true,"threshold":3.32},"spam_flag_threshold":6.2,"deny_message_threshold":15.72,"prefix_email_subject":{"enabled":true,"prefix":"spAM!"}}}

Check no bypass rules are present
    ${dpayload} =    Run task    module/${MID}/list-bypass-rules    ""    decode_json=${TRUE}
    Should Be Empty    ${dpayload}[bypass_rules]

Add some bypass rules
    Run task    module/${MID}/add-bypass-rule    {"type":"email","direction":"from","value":"dude@external.test"}
    Run task    module/${MID}/add-bypass-rule    {"type":"domain","direction":"from","value":"customer.domain.test"}
    Run task    module/${MID}/add-bypass-rule    {"type":"cidr","direction":"from","value":"10.3.4.0/24"}
    Run task    module/${MID}/add-bypass-rule    {"type":"ip","direction":"from","value":"10.9.8.7"}
    Run task    module/${MID}/add-bypass-rule    {"type":"ip","direction":"from","value":"2345:0425:2CA1:0000:0000:0567:5673:23b5"}
    Run task    module/${MID}/add-bypass-rule    {"type":"cidr","direction":"from","value":"2001:db8:1234::/48"}

Added bypass rules are present
    ${jpayload} =    Run task    module/${MID}/list-bypass-rules    ""    decode_json=${FALSE}
    Should Contain    ${jpayload}    "dude@external.test"
    Should Contain    ${jpayload}    "customer.domain.test"
    Should Contain    ${jpayload}    "10.3.4.0/24"
    Should Contain    ${jpayload}    "10.9.8.7"
    Should Contain    ${jpayload}    "2345:0425:2CA1:0000:0000:0567:5673:23b5"
    Should Contain    ${jpayload}    "2001:db8:1234::/48"

Changed settings were applied
    ${dpayload} =    Run task    module/${MID}/get-filter-configuration    ""    decode_json=${TRUE}
    Should Be Equal As Numbers    ${dpayload}[antispam][greylist][threshold]    3.32
    Should Be Equal As Numbers   ${dpayload}[antispam][spam_flag_threshold]    6.2
    Should Be Equal As Numbers   ${dpayload}[antispam][deny_message_threshold]    15.72
    Should Be Equal    ${dpayload}[antivirus][clamav_official_sigs]    ${TRUE}
    Should Be Equal    ${dpayload}[antivirus][third_party_sigs_rating]    high
    Should Be Equal As Integers   ${dpayload}[bypass_rules]    6

Remove the bypass rules
    Run task    module/${MID}/remove-bypass-rule    {"type":"email","direction":"from","value":"dude@external.test"}
    Run task    module/${MID}/remove-bypass-rule    {"type":"domain","direction":"from","value":"customer.domain.test"}
    Run task    module/${MID}/remove-bypass-rule    {"type":"cidr","direction":"from","value":"10.3.4.0/24"}
    Run task    module/${MID}/remove-bypass-rule    {"type":"ip","direction":"from","value":"10.9.8.7"}
    Run task    module/${MID}/remove-bypass-rule    {"type":"ip","direction":"from","value":"2345:0425:2CA1:0000:0000:0567:5673:23b5"}
    Run task    module/${MID}/remove-bypass-rule    {"type":"cidr","direction":"from","value":"2001:db8:1234::/48"}

Check again no bypass rules are present
    ${dpayload} =    Run task    module/${MID}/list-bypass-rules    ""    decode_json=${TRUE}
    Should Be Empty    ${dpayload}[bypass_rules]
