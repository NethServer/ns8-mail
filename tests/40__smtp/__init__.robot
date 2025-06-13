*** Settings ***
Resource     senddeliver.resource
Suite Setup        Run keywords
                   ...    Create mail domains
                   ...    Assign public IP address
Suite Teardown     Destroy mail domains
