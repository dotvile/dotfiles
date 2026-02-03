init_ssh_agent() {
  if [ -f "$HOME/.ssh/agent.env" ]; then
    source "$HOME/.ssh/agent.env" > /dev/null 2>&1
  fi

  if [ -z "$SSH_AGENT_PID" ] || ! ps -p $SSH_AGENT_PID > /dev/null 2>&1; then
    ssh_agent_output=$(ssh-agent -s)

    formatted_output=$(echo "$ssh_agent_output" | awk '{ gsub(/; /, "\n"); print}' | grep -v "echo" | tr '\n' '; ' | awk '{ gsub(/;;/, ";"); print}')

    echo "$formatted_output" > "$HOME/.ssh/agent.env"

    source "$HOME/.ssh/agent.env"

    ssh-add ~/.ssh/github
  fi
}
