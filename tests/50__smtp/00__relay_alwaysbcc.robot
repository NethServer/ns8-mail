*** Settings ***
Documentation    General switch for mail archiving
Resource    smtp.resource
Suite Setup        Set alwaysbcc
Suite Teardown     Reset alwaysbcc
Test Tags    alwaysbcc

*** Test Cases ***
Inbound message Bcc
    Skip    not implemented

Outbound message Bcc
    Skip    not implemented

Piler Mail archive Bcc
    [Setup]        Add Piler relay rule
    [Teardown]     Remove Piler relay rule
    Skip    not implemented

*** Keywords ***
Set alwaysbcc
    Skip    not implemented

Reset alwaysbcc
    Skip    not implemented

Add Piler relay rule
    Skip    not implemented

Remove Piler relay rule
    Skip    not implemented

