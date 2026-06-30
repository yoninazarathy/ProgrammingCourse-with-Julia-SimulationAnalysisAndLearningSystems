# Sample 5-minute task stub: Count unique integers in a vector
# Instructions for students:
# - Implement the function `solve(xs)` below.
# - It should return the number of distinct integer values in `xs`.
# - Use only Base Julia. Keep it simple and fast.
# - Test locally by running:
#     julia quicktext/quickgrader.jl --task quicktext/sample_task_count_unique.jl --uqid s1234567 --taskid L8Q3 --secret L8_2025_10_28 --tasktype count_unique
# - If you pass, you'll see:  PASS … token: ABC123 (example)
# - Submit the token to the Google Form.

"""
    solve(xs)

Return the number of distinct integers in xs.
Examples:
    solve(Int[]) == 0
    solve([1]) == 1
    solve([1,1,1]) == 1
    solve([1,2,2,3]) == 3
"""
function solve(xs)
    # Simple reference implementation
    length(Set(xs))
end
