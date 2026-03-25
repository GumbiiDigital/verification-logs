#!/bin/bash
# verify_and_log.sh — 3-signal verification, log, commit, push every 5 minutes
# Run in tmux: tmux new-session -d -s verify "bash ~/verification_logs/verify_and_log.sh"

LOGFILE="$HOME/verification_logs/verification.log"
cd "$HOME/verification_logs"

# Init git repo if needed
if [ ! -d .git ]; then
    git init
    git remote add origin git@github.com:GumbiiDigital/verification-logs.git 2>/dev/null || true
fi

while true; do
    TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

    # Signal 1: Process tree
    TMUX_SESSIONS=$(tmux list-sessions 2>/dev/null | wc -l)
    GEN_PROCS=$(pgrep -c -f "entry.py" 2>/dev/null || echo 0)
    GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null || echo "N/A")
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null || echo "N/A")

    # Signal 2: Latest log entries
    PHASE1_LAST=$(tail -1 /tmp/batch_davinci_v2.log 2>/dev/null || echo "N/A")
    PHASE2_LAST=$(tail -1 /tmp/phase2_batch.log 2>/dev/null || echo "N/A")
    WATCHER_LAST=$(tail -1 /tmp/phase1_watcher.log 2>/dev/null || echo "N/A")

    # Signal 3: Artifact counts
    P1_VIDS=$(ls ~/daVinci-MagiHuman/batch_output_20260325_154259/*.mp4 2>/dev/null | wc -l)
    P1_SCORES=$(wc -l < ~/daVinci-MagiHuman/batch_output_20260325_154259/results_original.jsonl 2>/dev/null || echo 0)
    P2_DIR=$(ls -d ~/daVinci-MagiHuman/phase2_output_* 2>/dev/null | head -1)
    P2_VIDS=0
    if [ -n "$P2_DIR" ]; then
        P2_VIDS=$(ls "$P2_DIR"/*.mp4 2>/dev/null | wc -l)
    fi
    HTTP_OK=$(curl -s --max-time 2 -o /dev/null -w "%{http_code}" http://localhost:9090/ 2>/dev/null || echo "DOWN")

    # Write entry
    ENTRY="=== $TIMESTAMP ===
S1-PROCS: tmux=$TMUX_SESSIONS gen=$GEN_PROCS gpu=${GPU_UTIL} temp=${GPU_TEMP}C
S2-LOGS:
  phase1: $PHASE1_LAST
  phase2: $PHASE2_LAST
  watcher: $WATCHER_LAST
S3-ARTIFACTS: p1_vids=${P1_VIDS}/56 p1_scores=${P1_SCORES}/28 p2_vids=${P2_VIDS} http=${HTTP_OK}
---"

    echo "$ENTRY" >> "$LOGFILE"
    echo "$ENTRY"

    # Git commit and push
    git add -A
    git commit -m "verify: ${TIMESTAMP} | p1=${P1_VIDS}/56 p2=${P2_VIDS} gpu=${GPU_UTIL}" --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || git push origin master --quiet 2>/dev/null || true

    sleep 300
done
