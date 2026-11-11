*** Settings ***
Resource    ../api.resource

*** Test Cases ***
Collect facts
    ${out} =    Run task    module/${MID}/get-facts    ""
    Should Not Be Empty    ${out}
    Should Be Equal As Integers    ${out}[dovecot_default_process_limit]    400
