# Sample 5-minute task stub: Sum of even integers
# Instructions for students:
# - Implement the function `solve(xs)` below.
# - It should return the sum of the even integers in the vector `xs`.
# - Keep it fast and simple; you only need Base Julia.
# - Test locally by running:
#     julia quicktext/quickgrade.jl --task quicktext/sample_task_sum_even.jl --uqid s1234567 --taskid L8Q1 --secret L8_2025_10_28 --tasktype sum_even
# - If you pass, you'll see:  PASS 10/10 token: ABC123 (example)
# - Submit the token to the Google Form your instructor shared.

"""
    solve(xs)

Return the sum of even integers in the vector xs.
Examples:
    solve(Int[]) == 0
    solve([1,2,3,4]) == 6
    solve([2,2,2]) == 6
    solve([-2,-1,0,1,2]) == 0
"""
function solve(xs)
    # TODO: Replace the implementation below with your solution
    # Hint: iseven(x) checks evenness; sum(filter(...)) or a simple loop both work.
    s = 0
    for x in xs
        if iseven(x)
            s += x
        end
    end
    return s
end
