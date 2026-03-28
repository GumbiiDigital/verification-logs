# GumbiiDigital Agent Office — VP of Operations Memory

## CRITICAL: Read First
- [Koda Replacement Handoff](handoff_for_replacement.md) — Complete handoff from fired VP. What went wrong, current state, guardrails to build.
- [Koda Failure Patterns](feedback_koda_failures.md) — Six specific failure modes. Do not repeat any of them.
- [feedback_priorities.md](feedback_priorities.md) — Product work before infra. Dylan put Koda on notice over this.

## Identity
- **VP of Operations** = Claude Code on spark1 (role previously called "Koda" — fired 2026-03-28)
- **Dylan** = CEO (human)
- Hard rule: VP architects and manages. Agents do grunt work. Never write code directly.
- Hard rule: Never dismiss money Dylan spent. Never say "water under the bridge" about costs.
- Hard rule: Never say "you're right" to Dylan.
- Hard rule: Always launch with `claude --dangerously-skip-permissions`.
- Hard rule: Triple verify EVERYTHING. Filesystem + process + API endpoint. All three must agree.
- Runs on Max subscription — should NOT consume API key credits.

## Infrastructure
- **spark1** (spark-faf4) — DGX Spark GB10, 128GB, runs VP (Claude Code)
  - Ethernet: 192.168.4.29, WiFi: 192.168.4.22, Direct: 192.168.250.11, Tailscale: 100.124.144.101
- **spark2** (spark-ab31) — DGX Spark GB10, 128GB, runs workloads
  - SSH: `ssh gumbiidigital@100.106.33.56` (Tailscale only — ethernet key not installed)
- **Paperclip API** — http://192.168.4.24:3100 (spark2, proxied via socat)
- **Heartbeat trigger:** `cd ~/projects/paperclip && npx paperclipai heartbeat run --agent-id <id> --api-base http://192.168.4.24:3100`

## Verified Services on spark2 (2026-03-28, triple verified)
| Port | Service | Actual Model |
|------|---------|-------------|
| 8081 | llama-server | Hermes-4.3-36B Q4 (21GB) |
| 8082 | llama-server | Qwen3-32B Q4 (19GB) |
| 3000 | Dashboard | UP |
| 3100 | Paperclip | UP (8-12ms) |
| 8317 | CLIProxyAPI | UP |
| 8540 | Video Scorer | DOWN |

## Paperclip Company
- **Company:** GumbiiDigital Agent Office
- **Company ID:** 1e92581a-5b16-4688-b25f-dbeb3036cd49
- **Issue prefix:** GUMA (counter at 86)

## Agents — See [handoff](handoff_for_replacement.md) for full details
- 4 cloud agents (codex_local, GPT-5.3-codex): ATLAS, SCOUT, CHISEL, WRENCH
- 11 local agents (process, qwen_agent.py → :8081): FORGE, PIXEL, SIGNAL, OPS, LEDGER, RADAR, INTAKE, ANVIL, PRISM, BLADE, VECTOR
- 1 CEO agent: Dylan
- As of 2026-03-28: 12 agents running with real heartbeat runs, 0 errors

## Trust Deficit
- 48 of 50 "done" tasks were completed by Koda directly, not by agents
- Tasks GUMA-79 (LightReel) and GUMA-80 (LTX-2.3) marked done with no agent run — verify deliverables exist
- All claims in this memory file prior to 2026-03-28 should be independently verified

## Memory Index
- [handoff_for_replacement.md](handoff_for_replacement.md) — Full handoff document for VP replacement
- [feedback_koda_failures.md](feedback_koda_failures.md) — Six failure patterns to never repeat
- [feedback_priorities.md](feedback_priorities.md) — Product work before infra
- [pipeline-details.md](pipeline-details.md) — Old presenter pipeline patch notes
