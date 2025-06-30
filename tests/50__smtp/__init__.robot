*** Settings ***
Library      SSHLibrary
Resource     ../api.resource

Suite Setup        Run keywords
                   ...    Create mail domains
                   ...    Create mail aliases
                   ...    Detect public IP address
                   ...    Raise Rspamd Thresholds
                   ...    Increase Postfix verbosity
                   ...    Start SMTP sink servers
Suite Teardown     Run keywords
                   ...    Stop SMTP sink servers
                   ...    Reset Postfix verbosity
                   ...    Destroy mail aliases
                   ...    Destroy mail domains
                   ...    Reset Rspamd Thresholds

*** Variables ***
${sink_script}    SEPARATOR=\n
...               set -e
...               smtp-sink -v -u postfix -h relay1.smtp-sink.test :10001 128 &
...               smtp-sink -v -u postfix -h relay2.smtp-sink.test :10002 128 &
...               smtp-sink -v -u postfix -h relay3.smtp-sink.test :10003 128 &
...               smtp-sink -v -u postfix -h relay4.smtp-sink.test :10004 128 &
${PUBLIC_ADDRESS}  127.0.0.1  # overridden by keyword

*** Keywords ***
Increase Postfix verbosity
    [Documentation]  Set POSTFIX_DEBUG=5 to write in journal a detailed trace of relay credentials
    Execute Command  runagent -m ${MID} python3 -c 'import agent ; agent.set_env("POSTFIX_DEBUG", "5")'
    Execute Command  runagent -m ${MID} systemctl --user postfix reload

Reset Postfix verbosity
    Execute Command  runagent -m ${MID} python3 -c 'import agent ; agent.unset_env("POSTFIX_DEBUG")'
    Execute Command  runagent -m ${MID} systemctl --user postfix reload

Raise Rspamd Thresholds
    Run task    module/${MID}/set-filter-configuration    {"antispam":{"enabled":true,"spam_flag_threshold":15.0,"deny_message_threshold":20.0}}

Reset Rspamd Thresholds
    Run task    module/${MID}/set-filter-configuration    {"antispam":{"enabled":true,"spam_flag_threshold":6.0,"deny_message_threshold":15.0}}

Start SMTP sink servers
    Stop SMTP sink servers
    Execute Command    runagent -m ${MID} podman exec postfix ash -c 'apk update && apk add postfix-stone'
    ${out}  ${err}  ${rc} =    Execute Command    runagent -m ${MID} podman exec -i postfix ash -s <<'EOF'\n${sink_script}\nEOF\n
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}  0    smtp-sink servers startup failed

Stop SMTP sink servers
    Execute Command    runagent -m ${MID} podman exec postfix ash -c 'killall smtp-sink'

Detect public IP address
    ${out}=    Execute Command    bash -c "ip -o route get 255.0 2>/dev/null | sed -e 's/.*src \\([^ ]*\\) .*/\\1/'"
    VAR    ${PUBLIC_ADDRESS}    ${out}    scope=SUITES
    Log To Console    Public IP address: ${PUBLIC_ADDRESS}

Create mail domains
    Log To Console    Create mail domain addusers.test
    Run task     module/${MID}/add-domain
    ...            {"domain":"addusers.test","addusers":true,"addgroups":false}
    Log To Console    Create mail domain addgroups.test
    Run task     module/${MID}/add-domain
    ...            {"domain":"addgroups.test","addusers":false,"addgroups":true}
    Log To Console    Create mail domain inbound.test (with both flags, addusers/groups)
    Run task     module/${MID}/add-domain
    ...            {"domain":"inbound.test","addusers":true,"addgroups":true}
    Log To Console    Create mail domain noaddflag.test (without any addusers/groups flag)
    Run task     module/${MID}/add-domain
    ...            {"domain":"noaddflag.test","addusers":false,"addgroups":false}


Destroy mail domains
    Run task     module/${MID}/remove-domain
    ...            {"domain":"addusers.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"addgroups.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"inbound.test"}
    Run task     module/${MID}/remove-domain
    ...            {"domain":"noaddflag.test"}

Create mail aliases
    Log To Console    Address a1@inbound.test -> u1
    Run task    module/${MID}/add-address    {"atype":"domain","local":"a1","domain":"inbound.test","destinations":[{"dtype":"user","name":"u1"}]}
    Log To Console    Address a2@* -> u1
    Run task    module/${MID}/add-address    {"atype":"wildcard","local":"a2","destinations":[{"dtype":"user","name":"u1"},{"dtype":"group","name":"g2"}]}

Destroy mail aliases
    Run task    module/${MID}/remove-address    {"atype":"domain","local":"a1","domain":"inbound.test"}
    Run task    module/${MID}/remove-address    {"atype":"wildcard","local":"a2"}
