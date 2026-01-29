#!/bin/bash
# Auto-restart monitor for GPT-5 rerun
LOG_FILE="/path/to/ISO-Bench/vllm_gpt5_monitor.log"
RUN_LOG="/path/to/ISO-Bench/vllm_gpt5_rerun_cont.log"
SCRIPT="/tmp/restart_gpt5_fresh.sh"

while true; do
  # Check if bench.cli process is running
  if ! pgrep -f "bench.cli prepare" > /dev/null; then
    echo "$(date): Process died, cleaning and restarting..." | tee -a "$LOG_FILE"

    # Clean worktrees
    cd /path/to/ISO-Bench/perf-agents-bench
    rm -rf .work/worktrees/*
    git -C ../vllm worktree prune

    # Restart
    nohup "$SCRIPT" > "$RUN_LOG" 2>&1 &
    NEW_PID=$!
    echo $NEW_PID > /tmp/vllm_gpt5_rerun.pid
    echo "$(date): Restarted with PID: $NEW_PID" | tee -a "$LOG_FILE"

    sleep 30
  fi

  sleep 60
done
