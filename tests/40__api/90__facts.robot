*** Settings ***
Resource    ../api.resource

*** Test Cases ***
Collect facts
    ${out} =    Run task    module/${MID}/get-facts    ""
    Should Not Be Empty    ${out}
