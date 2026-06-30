# Option A: Lightweight in-lecture Julia tasks

This guide describes a minimal setup to run 5‑minute coding checks during lectures. Students run tests locally, get a short token on success, and submit it in a Google Form. You auto-verify in Sheets.

## Components
- `quicktext/quickgrader.jl` — grader harness (Base + SHA only)
- `quicktext/sample_task_*.jl` — example student stubs (solve(...) to implement)
- `quicktext/run_quickgrader.sh` — one-liner wrapper (env or flags)
- `quicktext/make_token.jl` — compute expected tokens manually
- `quicktext/LECTURE_TASK_TEMPLATE.md` — duplicate each lecture, replace placeholders

## Instructor setup per lecture (2–3 minutes)
1. Choose a simple function task (no external packages). Use or replace one of the sample stubs.
2. Set a fresh Secret and Task ID (rotate weekly), e.g., Secret: `L8_2025_10_28`, Task ID: `L8Q1`.
3. Share with students:
   - the task file path
   - a Google Form link to submit `uqid` and `token`
4. Close the form after 5 minutes.

## Student workflow
Students implement `solve(...)` and run one of the commands below. On PASS, they submit the token.

```bash
# Sum evens in a vector
julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_even.jl \
  --uqid s1234567 --taskid L8Q1 --secret L8_2025_10_28 --tasktype sum_even

# Count vowels (A/E/I/O/U)
julia quicktext/quickgrader.jl --task quicktext/sample_task_count_vowels.jl \
  --uqid s1234567 --taskid L8Q2 --secret L8_2025_10_28 --tasktype count_vowels

# Count unique integers
julia quicktext/quickgrader.jl --task quicktext/sample_task_count_unique.jl \
  --uqid s1234567 --taskid L8Q3 --secret L8_2025_10_28 --tasktype count_unique
```

Or via the launcher script:

```bash
export TASK_SECRET=L8_2025_10_28
export TASK_ID=L8Q1
export TASK_TYPE=sum_even
export UQID=s1234567
export TASK_FILE=quicktext/sample_task_sum_even.jl
./quicktext/run_quickgrader.sh
```

## How the token works
Token = first 6 hex chars of SHA1("<secret>|<taskid>|<uqid>|PASS"). Rotate Secret every lecture. Token depends on `uqid`, so copying tokens won’t help peers.

## Google Form + Sheets auto‑marking
1. Create a Form with fields `uqid` and `token`, link to a Sheet.
2. Add this Apps Script (Extensions → Apps Script):

```javascript
function SHA1HEX(s) {
  var raw = Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_1, s);
  return raw.map(function(b){return ('0'+(b & 0xFF).toString(16)).slice(-2)}).join('').toUpperCase();
}
```

3. Put your current `Secret` and `TaskID` in named cells (or a config tab).
4. Suppose column A = `uqid`, column B = `token`:

```
# Column C (Expected token)
=LEFT(SHA1HEX($Secret&"|"&$TaskID&"|"&A2&"|PASS"), 6)
# Column D (Correct?)
=IF(B2=C2, 1, 0)
```

## Tips
- Keep tasks simple and pure; run < 1s.
- Use Base only; avoid Pkg.
- Show one visible test example on the slide.
- If a student lacks Julia, allow short grace period or lab machine submission.

## Manual verification
Spot‑check tokens offline:

```bash
julia quicktext/make_token.jl L8_2025_10_28 L8Q1 s1234567
```
