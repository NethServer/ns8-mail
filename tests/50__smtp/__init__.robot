*** Settings ***
Resource     senddeliver.resource
Suite Setup        Run keywords
                   ...    Create mail domains
                   ...    Create mail aliases
                   ...    Assign public IP address
                   ...    Raise Rspamd Thresholds
Suite Teardown     Run keywords
                   ...    Destroy mail aliases
                   ...    Destroy mail domains
                   ...    Reset Rspamd Thresholds
