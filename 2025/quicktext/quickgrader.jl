#!/usr/bin/env julia
# Lightweight in-lecture grader for Julia tasks (Option A)
# Dependencies: Base + SHA (stdlib)
# Usage examples:
#   julia quickgrader.jl --task sample_task_sum_even.jl --uqid s1234567 --taskid L8Q1 --secret L8_2025_10_28 --tasktype sum_even
#   julia quickgrader.jl --task sample_task_count_vowels.jl --uqid s1234567 --taskid L8Q2 --secret L8_2025_10_28 --tasktype count_vowels

using SHA
using Random

# ---------------------
# CLI args
# ---------------------
mutable struct Args
    task::String
    uqid::String
    taskid::String
    secret::String
    tasktype::String
end

function parse_args(argv)
    task = ""
    uqid = ""
    taskid = get(ENV, "TASK_ID", "L8Q1")
    secret = get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE")
    tasktype = get(ENV, "TASK_TYPE", "sum_even")

    i = 1
    while i <= length(argv)
        arg = argv[i]
        if arg == "--task" && i < length(argv)
            task = argv[i+1]; i += 2; continue
        elseif arg == "--uqid" && i < length(argv)
            uqid = argv[i+1]; i += 2; continue
        elseif arg == "--taskid" && i < length(argv)
            taskid = argv[i+1]; i += 2; continue
        elseif arg == "--secret" && i < length(argv)
            secret = argv[i+1]; i += 2; continue
        elseif arg == "--tasktype" && i < length(argv)
            tasktype = argv[i+1]; i += 2; continue
        elseif arg in ("-h", "--help")
            print_help(); exit(0)
        else
            @warn "Unrecognized or incomplete argument" arg
            i += 1
        end
    end

    if isempty(task) || isempty(uqid)
        print_help()
        error("Missing required args: --task and --uqid")
    end

    return Args(task, uqid, taskid, secret, tasktype)
end

function print_help()
    println("Usage: julia quickgrader.jl --task <taskfile.jl> --uqid <s1234567> [--taskid <ID>] [--secret <SECRET>] [--tasktype <name>]")
    println("Env var alternatives: TASK_ID, TASK_SECRET, TASK_TYPE")
end

# ---------------------
# Utility
# ---------------------
compute_token(secret::AbstractString, taskid::AbstractString, uqid::AbstractString) = begin
    raw = string(secret, "|", taskid, "|", uqid, "|PASS")
    hex = uppercase(bytes2hex(sha1(raw)))
    return first(hex, 6)
end

struct TestFailure <: Exception
    msg::String
end

# ---------------------
# Task dispatch
# ---------------------
function run_task(tasktype::AbstractString)
    if tasktype == "sum_even"
        return run_sum_even()
    elseif tasktype == "count_vowels"
        return run_count_vowels()
    elseif tasktype == "count_unique"
        return run_count_unique()
    elseif tasktype == "sum_csv"
        return run_sum_csv()
    else
        return false, 0, 0, ["Unknown tasktype=$(tasktype)."]
    end
end

# Sum of even integers in a vector
function run_sum_even()
    feedback = String[]; total = 0; passed = 0
    if !isdefined(Main, :solve)
        push!(feedback, "Task file must define function `solve(xs)`.")
        return false, 0, 0, feedback
    end

    vis = [
        (Int[], 0),
        ([1,2,3,4], 6),
        ([2,2,2], 6),
        ([-2,-1,0,1,2], 0),
    ]
    for (inp, exp) in vis
        total += 1
        try
            out = Base.invokelatest(Main.solve, inp)
            if out != exp
                throw(TestFailure("Expected $(exp) for input $(inp)"))
            end
            passed += 1
        catch e
            push!(feedback, sprint(showerror, e))
        end
    end

    seed = foldl(+, codeunits(get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE") * get(ENV, "TASK_ID", "L8Q1")))
    rng = MersenneTwister(seed)
    for _ in 1:6
        n = rand(rng, 0:20)
        xs = [rand(rng, -50:50) for _ in 1:n]
        exp = sum(x for x in xs if iseven(x))
        total += 1
        try
            out = Base.invokelatest(Main.solve, xs)
            if out != exp
                throw(TestFailure("Hidden test failed for input of length $(n)"))
            end
            passed += 1
        catch e
            push!(feedback, "Hidden: " * sprint(showerror, e))
        end
    end

    return passed == total, passed, total, feedback
end

# Count vowels (A/E/I/O/U), case-insensitive
function run_count_vowels()
    feedback = String[]; total = 0; passed = 0
    if !isdefined(Main, :solve)
        push!(feedback, "Task file must define function `solve(s::AbstractString)` returning Int.")
        return false, 0, 0, feedback
    end

    vis = [
        ("", 0),
        ("abc", 1),
        ("AEIOU", 5),
        ("Julia", 3),
        ("Psychology", 2),
    ]
    for (inp, exp) in vis
        total += 1
        try
            out = Base.invokelatest(Main.solve, inp)
            if out != exp
                throw(TestFailure("Expected $(exp) for input \"$(inp)\""))
            end
            passed += 1
        catch e
            push!(feedback, sprint(showerror, e))
        end
    end

    seed = foldl(+, codeunits(get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE") * get(ENV, "TASK_ID", "L8Q1"))) + 12345
    rng = MersenneTwister(seed)
    alphabet = [collect('a':'z'); collect('A':'Z')]
    vowels = Set{Char}(['a','e','i','o','u','A','E','I','O','U'])
    for _ in 1:10
        n = rand(rng, 0:60)
        s = String(rand(rng, alphabet, n))
        exp = count(c -> c in vowels, s)
        total += 1
        try
            out = Base.invokelatest(Main.solve, s)
            if out != exp
                throw(TestFailure("Hidden test failed for random string of length $(n)"))
            end
            passed += 1
        catch e
            push!(feedback, "Hidden: " * sprint(showerror, e))
        end
    end

    return passed == total, passed, total, feedback
end

# Count unique integers in a vector
function run_count_unique()
    feedback = String[]; total = 0; passed = 0
    if !isdefined(Main, :solve)
        push!(feedback, "Task file must define function `solve(xs)` returning Int (count of distinct integers).")
        return false, 0, 0, feedback
    end

    # Visible tests
    vis = [
        (Int[], 0),
        ([1], 1),
        ([1,1,1], 1),
        ([1,2,2,3], 3),
        ([-1, -1, 0, 1], 3),
    ]
    for (inp, exp) in vis
        total += 1
        try
            out = Base.invokelatest(Main.solve, inp)
            if out != exp
                throw(TestFailure("Expected $(exp) unique values for input $(inp)"))
            end
            passed += 1
        catch e
            push!(feedback, sprint(showerror, e))
        end
    end

    # Hidden randomized tests
    seed = foldl(+, codeunits(get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE") * get(ENV, "TASK_ID", "L8Q1"))) + 24680
    rng = MersenneTwister(seed)
    for _ in 1:10
        n = rand(rng, 0:60)
        xs = [rand(rng, -20:20) for _ in 1:n]
        exp = length(Set(xs))
        total += 1
        try
            out = Base.invokelatest(Main.solve, xs)
            if out != exp
                throw(TestFailure("Hidden test failed for random list of length $(n)"))
            end
            passed += 1
        catch e
            push!(feedback, "Hidden: " * sprint(showerror, e))
        end
    end

    return passed == total, passed, total, feedback
end

# Sum comma-separated integers in a string (e.g., "1, 2,3" => 6)
function run_sum_csv()
    feedback = String[]; total = 0; passed = 0
    if !isdefined(Main, :solve)
        push!(feedback, "Task file must define function `solve(s::AbstractString)` returning Int (sum of CSV integers).")
        return false, 0, 0, feedback
    end

    # Visible tests (assume valid CSV of integers, optional spaces)
    vis = [
        ("", 0),
        ("0", 0),
        ("1,2,3", 6),
        ("10, -5, 2", 7),
        (" 7 , 8 ", 15),
    ]
    for (inp, exp) in vis
        total += 1
        try
            out = Base.invokelatest(Main.solve, inp)
            if out != exp
                throw(TestFailure("Expected $(exp) for input \"$(inp)\""))
            end
            passed += 1
        catch e
            push!(feedback, sprint(showerror, e))
        end
    end

    # Hidden randomized tests
    seed = foldl(+, codeunits(get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE") * get(ENV, "TASK_ID", "L8Q1"))) + 13579
    rng = MersenneTwister(seed)
    for _ in 1:10
        n = rand(rng, 0:12)
        nums = [rand(rng, -20:20) for _ in 1:n]
        # Randomly sprinkle spaces
        parts = String[]
        for x in nums
            left = rand(rng, 0:1) == 1 ? " " : ""
            right = rand(rng, 0:1) == 1 ? " " : ""
            push!(parts, string(left, x, right))
        end
        s = join(parts, ",")
        exp = sum(nums)
        total += 1
        try
            out = Base.invokelatest(Main.solve, s)
            if out != exp
                throw(TestFailure("Hidden test failed for CSV string of length $(length(s))"))
            end
            passed += 1
        catch e
            push!(feedback, "Hidden: " * sprint(showerror, e))
        end
    end

    return passed == total, passed, total, feedback
end

# ---------------------
# Main
# ---------------------
function main()
    args = parse_args(ARGS)
    ENV["TASK_SECRET"] = args.secret
    ENV["TASK_ID"] = args.taskid

    if !isfile(args.task)
        error("Task file not found: $(args.task)")
    end
    try
        include(args.task)
    catch e
        println("ERROR including task file: ", sprint(showerror, e))
        exit(2)
    end

    ok, passed, total, feedback = run_task(args.tasktype)
    if ok
        token = compute_token(args.secret, args.taskid, args.uqid)
        println("PASS $(passed)/$(total) token: $(token)")
        exit(0)
    else
        println("FAIL $(passed)/$(total)")
        for msg in feedback
            println(" - ", msg)
        end
        exit(1)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
