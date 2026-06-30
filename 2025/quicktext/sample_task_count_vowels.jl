# Sample 5-minute task stub: Count vowels in a string
# Instructions for students:
# - Implement the function `solve(s)` below.
# - It should return the number of vowels (A/E/I/O/U only) in the string `s`, case-insensitive.
# - Use only Base Julia. Keep it simple and fast.
# - Test locally by running:
#     julia quicktext/quickgrade.jl --task quicktext/sample_task_count_vowels.jl --uqid s1234567 --taskid L8Q2 --secret L8_2025_10_28 --tasktype count_vowels
# - If you pass, you'll see:  PASS … token: ABC123 (example)
# - Submit the token to the Google Form.

"""
    solve(s)

Return the number of vowels (A/E/I/O/U) in s, case-insensitive.
Examples:
    solve("") == 0
    solve("abc") == 1
    solve("AEIOU") == 5
    solve("Julia") == 3
"""
function solve(s)
    # Simple reference implementation
    count(c -> c in ('a','e','i','o','u','A','E','I','O','U'), s)
end
