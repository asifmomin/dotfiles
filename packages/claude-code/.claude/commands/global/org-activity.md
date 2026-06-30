---
description: Summarize recent commit activity across a GitHub org, grouped by author, since you last checked
argument-hint: [ORG] [WINDOW] [--no-summary] [--exclude @a,@b] | --set-default ORG | --list
---

# Org Activity Summary

Summarize commits pushed to any branch across **all repos in a GitHub org**, grouped by author, since the last time you ran this command for that org. State (default org + per-org `last_checked`) persists in `~/.claude/state/org-activity.json`.

## Input Handling

<input_handling>
`$ARGUMENTS` is a space-separated string. Split it and classify each token:

- `--set-default` / `--list` / `--no-summary` → flag
- `--exclude @login[,@login...]` → consumes the next token as a comma-separated exclusion list → `EXCLUDE`
- `^\d+[hdwm]$` (e.g. `24h`, `7d`, `2w`, `1m`) → duration → `WINDOW`
- Contains `-` **and** a 4-digit year (e.g. `2026-04-15`, `2026-04-15T10:00:00Z`) → ISO date → `WINDOW`
- Anything else → org name → `ORG`

If the user passed exactly one unrecognized token and no flag, treat it as `ORG`. If they passed two, first is `ORG`, second is `WINDOW`. Reject more than 2 non-flag tokens with a usage hint.

`--no-summary` suppresses the per-author and overall narrative summaries (step 6 "Summarization"). `--exclude` filters the named logins out of both the rendered groupings and the summary totals — strip a leading `@` if present.
</input_handling>

## Execution Steps

### 1. Load state

Read `~/.claude/state/org-activity.json`. Treat missing file or invalid JSON as `{"default_org": null, "orgs": {}}`. Do not create the file yet.

```bash
STATE_FILE="$HOME/.claude/state/org-activity.json"
if [ -f "$STATE_FILE" ]; then cat "$STATE_FILE"; else echo '{"default_org":null,"orgs":{}}'; fi
```

### 2. Handle flags (return early)

**`--set-default ORG`** — write `default_org = ORG` to state (preserve `orgs`), print `Default org set to ORG.`, stop.

**`--list`** — print a table of every key in `state.orgs` with its `last_checked` and mark which one is `default_org`. Stop.

### 3. Resolve `ORG`

Priority: `$ARGUMENTS` → `state.default_org` → prompt.

If prompting, use `AskUserQuestion` with one free-text question ("Which GitHub org?"). After fetching succeeds, if `state.default_org` was null, ask a yes/no follow-up: "Save $ORG as your default?"

### 4. Resolve `SINCE` (ISO-8601 UTC)

Priority: `WINDOW` arg → `state.orgs[$ORG].last_checked` → prompt.

Convert duration to absolute: `date -u -v-7d +%Y-%m-%dT%H:%M:%SZ` (macOS). For ISO-date input, append `T00:00:00Z` if no time component.

If prompting (first time for this org), `AskUserQuestion` with options: **Last 24 hours / Last 3 days / Last 7 days / Last 14 days**.

### 5. Fetch activity

**Step 5a — Get the list of recently-pushed repos** (cheap pre-filter, avoids hitting all N repos):

```bash
gh api "orgs/$ORG/repos?sort=pushed&direction=desc&per_page=100" --paginate \
  --jq '.[] | select(.pushed_at >= "'"$SINCE"'") | .full_name'
```

**Step 5b — Fetch commits per active repo in parallel**. Issue all calls in a **single message with multiple Bash tool uses** (one per repo) and run them in the background so they don't serialize:

```bash
gh api "repos/$REPO/commits?since=$SINCE&per_page=100" --paginate --jq '.[] | {
  repo: "'"$REPO_SHORT"'",
  sha: .sha[0:7],
  actor: (.author.login // .commit.author.email),
  name: .commit.author.name,
  msg: (.commit.message | split("\n")[0]),
  date: .commit.author.date,
  url: .html_url
}'
```

After all calls return, concatenate the NDJSON outputs and `jq -s '.'` into a single array for grouping.

**Limitation**: `/repos/{repo}/commits` defaults to the default branch. Commits on feature branches that haven't been merged yet won't appear. State this caveat in the rendered output footer (e.g. "_Default-branch commits only — feature-branch pushes not included._").

**Why not `/orgs/$ORG/events`?** The org-level events endpoint frequently omits the `payload.commits` array and truncates to ~300 recent events across the org, so it misses pushes on active repos. We tried it; it surfaced only 2/17 active repos on a real run. The per-repo approach above is authoritative.

### 6. Group and render

- If `EXCLUDE` is set, drop those actors from the commit list *before* grouping so they're absent from both the listing and the summary totals.
- Group by `actor` (GitHub login). Sort groups by commit count desc.
- Inside each group, sort by repo (most commits first), then by commit date desc.
- Output shape:

```markdown
## github.com/orgs/<ORG> — activity <SINCE_SHORT> → <NOW_SHORT> UTC

### @<login> — N commits across M repos
_<1–3 sentence summary of what this author worked on — see Summarization below>_
- **<repo-short-name>** (<n>)
  - `<sha>` <first line of commit message>
  - ...

### @<next-login> — ...

## Summary
<authors> authors · <commits> commits · <repos> repos touched
**Themes:** <1–3 sentences on cross-repo threads, new repos, notable patterns>
Next `/global:org-activity` for <ORG> will show commits after <NEW_TIMESTAMP>.
```

If the event list is empty: print `No commits in window.` and still proceed to step 7.

#### Summarization

Unless `--no-summary` was passed, synthesize two kinds of narrative from commit subjects:

- **Per-author summary** (one italicized line under each `### @<login>` header): 1–3 sentences describing *what changed and why*, not a restatement of commit subjects. Collapse rapid-iteration fix chains (e.g. `fix(migrate): baseline …`, `fix(migrate): bump baseline …`, `fix(migrate): call atlas CLI directly`) into one idea ("iterated on Atlas migration baselining"). Mention the repos touched if >1. Prefer neutral phrasing — don't editorialize on quality or velocity.
- **Themes** (under `## Summary`): 1–3 sentences calling out cross-repo threads (same feature landing in multiple repos), new repos appearing (first commit = "Initial commit/import"), or notable shifts in focus. Skip if nothing connects across authors or repos.

When `--no-summary` is passed, omit both the per-author italic line and the `**Themes:**` line; render only the grouped commit list and the raw totals.

### 7. Persist state atomically

Write a new JSON with:
- `default_org`: preserved (or newly set if user opted in at step 3)
- `orgs[$ORG].last_checked`: **now** in UTC ISO-8601 (`date -u +%Y-%m-%dT%H:%M:%SZ`)
- Other orgs' entries preserved verbatim

```bash
mkdir -p "$HOME/.claude/state"
# Seed if missing (use `printf … >|` to bypass zsh noclobber)
[ -f "$STATE_FILE" ] || printf '%s\n' '{"default_org":null,"orgs":{}}' >| "$STATE_FILE"
TMP=$(mktemp)
jq --arg org "$ORG" --arg now "$NOW" \
   '.orgs[$org].last_checked = $now' "$STATE_FILE" > "$TMP" && command mv -f "$TMP" "$STATE_FILE"
```

Use `command mv -f` (not bare `mv`) — the user may have `alias mv='mv -i'` which prompts on overwrite. Similarly, use `>|` instead of `>` for the seed file to bypass `setopt noclobber`.

## Usage Examples

```
/global:org-activity                                  # default org, delta since last run
/global:org-activity SkillBench-AI                    # specific org, delta since its last run
/global:org-activity 7d                               # default org, force 7-day window
/global:org-activity anthropic 2026-04-01             # specific org, since explicit date
/global:org-activity --no-summary                     # skip narrative summaries, raw commit list only
/global:org-activity --exclude @asifmomin-ee          # everyone else's work
/global:org-activity --exclude @me,@bot-account 7d    # multiple exclusions + window
/global:org-activity --set-default SkillBench-AI
/global:org-activity --list
```

## Notes

- Requires `gh` CLI authenticated with `read:org` scope (check with `gh auth status`).
- `gh api /orgs/$ORG/events` retains ~90 days of history — windows older than that will under-report via the primary path; the fallback (per-repo `/commits?since=`) has no such limit but is default-branch only.
- State file contains only org names and timestamps — safe to leave unencrypted.
