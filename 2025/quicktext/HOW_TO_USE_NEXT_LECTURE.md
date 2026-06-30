# How to use in your next lecture

A fast, low-overhead recipe to run a 5‑minute coding check with automatic verification and token submission.

## Instructor setup
- Pick a fresh secret and task id (rotate each lecture), e.g.:
  - Secret: `L8_2025_10_28`
  - Task ID: `L8Q1`
- Share with students:
  - The task file path (e.g., `quicktext/sample_task_sum_even.jl` or `quicktext/sample_task_count_vowels.jl`).
  - The Google Form link that collects: `uqid` and `token`.
- Close the form at the 5‑minute mark.

## Student workflow
1) Students implement `solve(...)` in the provided file.
2) They run the grader locally (replace values as appropriate):

```bash
# Array task example
julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_even.jl \
  --uqid s1234567 --taskid L8Q1 --secret L8_2025_10_28 --tasktype sum_even

# String task example
julia quicktext/quickgrader.jl --task quicktext/sample_task_count_vowels.jl \
  --uqid s1234567 --taskid L8Q2 --secret L8_2025_10_28 --tasktype count_vowels
```

3) If it prints `PASS … token: ABC123`, they paste that token into the Google Form.

## Auto‑marking in Google Sheets
- Link the Form to a Sheet (Responses → Link to Sheets).
- Add this Apps Script once (Extensions → Apps Script):

```javascript
function SHA1HEX(s) {
  var raw = Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_1, s);
  return raw.map(function(b){return ('0'+(b & 0xFF).toString(16)).slice(-2)}).join('').toUpperCase();
}
```

- Put your lecture’s `Secret` and `TaskID` in cells (or a config tab).
- Suppose column A = `uqid`, column B = `token` from the Form. Then:

```
# Column C (Expected token):
=LEFT(SHA1HEX($Secret&"|"&$TaskID&"|"&A2&"|PASS"), 6)

# Column D (Correct?):
=IF(B2=C2, 1, 0)
```

- Sum column D for marks and export if needed.

## Tips
- Keep tasks pure and small; run < 1 second.
- Avoid external packages; use Base only.
- Show one visible example on the slide to reduce friction.
- If any student lacks a working Julia install, allow a short grace period or lab submission with the same secret.
