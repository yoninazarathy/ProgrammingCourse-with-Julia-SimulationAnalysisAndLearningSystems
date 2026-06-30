# Sample 5-minute task stub: Sum of comma-separated integers
# Instructions for students:
# - Implement the function `solve(s)` below.
# - It should return the sum of integers in a comma-separated string `s`.
# - Assume valid input: integers separated by commas, optional spaces; empty string means 0.
# - Test locally by running:
#     julia quicktext/quickgrader.jl --task quicktext/sample_task_sum_csv.jl --uqid s1234567 --taskid L8Q4 --secret L8_2025_10_28 --tasktype sum_csv
# - If you pass, you'll see:  PASS … token: ABC123 (example)
# - Submit the token to the Google Form.

"""
    solve(s)

Return the sum of comma-separated integers in s.
Examples:
    solve("") == 0
    solve("1,2,3") == 6
    solve("10, -5, 2") == 7
"""
function solve(s)
    isempty(s) && return 0
    # Split on commas, strip spaces, parse, and sum
    parts = split(s, ",")
    total = 0
    for p in parts
        t = strip(p)
        if isempty(t)
            continue
        end
        total += parse(Int, t)
    end
    return total
end
