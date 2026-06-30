#!/usr/bin/env bash
# Wrapper to run quickgrader.jl with environment variables or flags
# Usage examples:
#   TASK_SECRET=L8_2025_10_28 TASK_ID=L8Q1 TASK_TYPE=sum_even \
#   UQID=s1234567 TASK_FILE=quicktext/sample_task_sum_even.jl \
#   ./quicktext/run_quickgrader.sh
#
# Or with flags:
#   ./quicktext/run_quickgrader.sh --secret L8_2025_10_28 --taskid L8Q1 \
#     --tasktype sum_even --uqid s1234567 --task quicktext/sample_task_sum_even.jl

set -euo pipefail

# Defaults from env (can be overridden by flags)
SECRET=${TASK_SECRET:-}
TASKID=${TASK_ID:-}
TASKTYPE=${TASK_TYPE:-sum_even}
UQID=${UQID:-}
TASKFILE=${TASK_FILE:-}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --secret) SECRET="$2"; shift 2;;
    --taskid) TASKID="$2"; shift 2;;
    --tasktype) TASKTYPE="$2"; shift 2;;
    --uqid) UQID="$2"; shift 2;;
    --task) TASKFILE="$2"; shift 2;;
    -h|--help)
      echo "Usage: TASK_SECRET=... TASK_ID=... TASK_TYPE=... UQID=... TASK_FILE=... ./run_quickgrader.sh"
      echo "   or: ./run_quickgrader.sh --secret ... --taskid ... --tasktype ... --uqid ... --task <file>"
      exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

if [[ -z "$TASKFILE" || -z "$UQID" || -z "$SECRET" || -z "$TASKID" ]]; then
  echo "Missing required inputs. Provide --task, --uqid, --secret, --taskid (or set env vars)." >&2
  exit 2
fi

exec julia "$(dirname "$0")/quickgrader.jl" --task "$TASKFILE" \
  --uqid "$UQID" --taskid "$TASKID" --secret "$SECRET" --tasktype "$TASKTYPE"
