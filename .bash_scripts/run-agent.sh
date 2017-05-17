#!/bin/bash
function sshagent() {
    local ssh_agent_auth=~/.ssh/ssh_agent_auth

    local ssh_agent_pid=$(ps -ef|awk '! /awk/ && /ssh-agent/{print $2}')
    if [[ -z ${ssh_agent_pid} ]]; then
        ssh-agent >| ${ssh_agent_auth}
    fi
    ssh_agent_pid=$(ps -ef|awk '! /awk/ && /ssh-agent/{print $2}')
    source ${ssh_agent_auth}
    if [[ "${ssh_agent_pid}" != "${SSH_AGENT_PID}" ]]; then
        echo "Not handling localy spawned angents, it may be more then one ssh agent"
        echo "Error spawing agent, pid ${SSH_AGENT_PID} is not equal to running agent ${ssh_agent_pid}"
        return
    fi

    echo -e "Agent PID=${SSH_AGENT_PID}\nAgent Keys"

    while [ $# -ne 0 ] ; do
        ssh-add  $1;
        shift;
    done
    ssh-add -l
    echo ""
}
