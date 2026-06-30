# Quick in-lecture Julia tasks (Option A)

A minimal, infrastructure-light workflow to run 5-minute coding checks in lectures. Students solve locally, get instant feedback, and submit a short token via a Google Form for auto-marking.

Contents:
- `quickgrade.jl` — grader harness (no external deps; uses stdlib `SHA`)
- `sample_task_sum_even.jl` — example student stub (function `solve` for arrays)
- `sample_task_count_vowels.jl` — example student stub (function `solve` for strings)
 - `sample_task_count_unique.jl` — example student stub (function `solve` for vectors)
 - `sample_task_sum_csv.jl` — example student stub (function `solve` for CSV strings)
- `run_quickgrader.sh` — one-liner launcher (reads env vars or flags)
- `LECTURE_TASK_TEMPLATE.md` — duplicate per lecture; replace SECRET/TASKID placeholders
 - `HOW_TO_USE_OPTION_A.md` — full Option A guide you can share or adapt
- `make_token.jl` — helper to compute expected token manually

## Instructor checklist (2–3 minutes per lecture)
1. Choose a simple task with a single function signature `solve(args...)`.
2. Set a fresh secret and task id:
   - Either pass flags `--secret` and `--taskid` to `quickgrade.jl`,
   - or set environment variables `TASK_SECRET` and `TASK_ID`.
3. Share with students:
   - The task file path (or paste the function stub into your LMS/slide).
   - A Google Form link with fields: `uqid` (or student number) and `token`.
4. Close the form at the 5-minute mark.

## Student workflow (what you tell them)
1. Implement `solve` in the provided file.
2. Run the grader locally (replace values as appropriate):

```bash
julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_even.jl \
  --uqid s1234567 --taskid L8Q1 --secret L8_2025_10_28 --tasktype sum_even
```

3. If it prints `PASS … token: ABC123`, paste that token into the Google Form.

Or run the string task:

```bash
julia quicktext/quickgrader.jl --task quicktext/sample_task_count_vowels.jl \
  --uqid s1234567 --taskid L8Q2 --secret L8_2025_10_28 --tasktype count_vowels
```

Or the CSV string task:

```bash
julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_csv.jl \
  --uqid s1234567 --taskid L8Q4 --secret L8_2025_10_28 --tasktype sum_csv
```

Or use the launcher script with env vars:

```bash
export TASK_SECRET=L8_2025_10_28
export TASK_ID=L8Q1
export TASK_TYPE=sum_even
export UQID=s1234567
export TASK_FILE=quicktext/sample_task_sum_even.jl
./quicktext/run_quickgrader.sh
```

## How the token works
- Token = first 6 hex chars of `SHA1("<secret>|<taskid>|<uqid>|PASS")`.
- Because the token depends on `uqid`, sharing a token won’t help peers.
- Rotate `secret` each lecture.

## Google Form + Sheet auto-marking
1. Create a Form with fields:
   - `uqid` (short answer)
   - `token` (short answer)
2. Link the form to a Google Sheet (Responses → Link to Sheets).
3. In the Sheet, add this Apps Script once (Extensions → Apps Script):

```javascript
function SHA1HEX(s) {
  var raw = Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_1, s);
  return raw.map(function(b){return ('0'+(b & 0xFF).toString(16)).slice(-2)}).join('').toUpperCase();
}
```

4. In the Sheet, add named cells for your current lecture (e.g., on a config tab):
   - `Secret` (e.g., `L8_2025_10_28`)
   - `TaskID` (e.g., `L8Q1`)

5. Suppose column A = `uqid`, column B = `token` from the Form. Put these formulas:
   - Column C (`Expected`):
     ```
     =LEFT(SHA1HEX($Secret&"|"&$TaskID&"|"&A2&"|PASS"), 6)
     ```
   - Column D (`Correct?`):
     ```
     =IF(B2=C2, 1, 0)
     ```

6. Sum Column D for marks or export as CSV.

## Defining a new task
- Keep the function name `solve` and choose simple inputs/outputs.
- For light reuse, `quickgrade.jl` currently includes built-in runners for `--tasktype sum_even` and `--tasktype count_vowels`.
- To add your own task type:
  1. Add a new `run_<name>()` in `quickgrade.jl` with visible tests and hidden tests.
  2. Branch in `run_task(tasktype)` to call it.
  3. Set `--tasktype <name>` when grading.

Hidden tests
- Use `TASK_SECRET` and `TASK_ID` as seeds to randomize tests deterministically per lecture.
- Don’t reveal the secret to students; pass via CLI or environment variable.

## Alternatives
- If you prefer not to edit `quickgrade.jl` for each task: keep using `sum_even` pattern and just swap the task file and visible tests on slides (hidden tests will still gate the pass/token).
- For heavier automation/integration: consider LMS CodeRunner or Gradescope Autograder.

## Troubleshooting
- `ERROR including task file`: the student file had a syntax error. Ask them to fix and re-run.
- `Task file must define function solve(xs)`: ensure the function name/signature matches what the runner expects.
- No Julia installed: allow later submission from lab machines, or provide a one-off backup question.

## Per-lecture template
- Duplicate `quicktext/LECTURE_TASK_TEMPLATE.md`, replace SECRET_HERE and TASKID_HERE, and share the appropriate command.

## Manual verification
- Compute a token for any `uqid` to spot-check Form responses:

```bash
julia quicktext/make_token.jl L8_2025_10_28 L8Q1 s1234567
```
