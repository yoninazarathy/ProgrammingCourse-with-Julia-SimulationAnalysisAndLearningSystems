# Lecture mini-task (5 minutes)

Replace the placeholders SECRET_HERE and TASKID_HERE, then share the relevant command with students.

- Secret: SECRET_HERE
- Task ID: TASKID_HERE
- Google Form link: PASTE_YOUR_FORM_URL_HERE

## Student instructions
Implement the function in the provided file and run the command below. On success, a token will be printed. Paste the token into the Google Form.

### Option A: Array task (sum of evens)
```bash
julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_even.jl \
  --uqid sXXXXXXX --taskid TASKID_HERE --secret SECRET_HERE --tasktype sum_even
```

### Option B: String task (count vowels)
```bash
julia quicktext/quickgrader.jl --task quicktext/sample_task_count_vowels.jl \
  --uqid sXXXXXXX --taskid TASKID_HERE --secret SECRET_HERE --tasktype count_vowels
```

## Instructor checklist
- Rotate Secret and TaskID each lecture.
- Keep the Google Form responses linked to a Sheet with the SHA1HEX Apps Script.
- In the Sheet, compute Expected token as:
```
=LEFT(SHA1HEX($Secret&"|"&$TaskID&"|"&A2&"|PASS"), 6)
```
- Mark correctness by comparing Submitted token to Expected.
