#!/usr/bin/env julia
# Lightweight in-lecture grader for Julia tasks (Option A)
# Dependencies: Base + SHA (stdlib)
# Usage:
#   julia quickgrade.jl --task sample_task_sum_even.jl --uqid s1234567 [--taskid L8Q1] [--secret L8_2025_10_28] [--tasktype sum_even]
#   julia quickgrade.jl --task sample_task_count_vowels.jl --uqid s1234567 [--taskid L8Q2] [--secret L8_2025_10_28] [--tasktype count_vowels]
# Notes:
# - Students only need to edit the task file (implement `solve`).
# - Instructor rotates `--secret` per lecture and sets `--taskid`.
# - Token = first 6 hex chars of SHA1("<secret>|<taskid>|<uqid>|PASS").

using SHA
using Random

# ---------------------
# CLI arg parsing (no external deps)
# ---------------------
mutable struct Args
    task::String
    uqid::String
    taskid::String
    secret::String
    tasktype::String
end

function parse_args(argv)
    # defaults (instructor should override secret/taskid)
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
            print_help()
            exit(0)
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
    println("Usage: julia quickgrade.jl --task <taskfile.jl> --uqid <s1234567> [--taskid <ID>] [--secret <SECRET>] [--tasktype <name>]")
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

# Ensure we can catch assertion failures
struct TestFailure <: Exception
    msg::String
end

macro require(cond, msg)
    return :( ($cond) || throw(TestFailure($msg)) )
end

# ---------------------
# Task runners (add branches for new task types)
# Each returns (passed::Bool, passed_count::Int, total::Int, feedback::Vector{String})
# ---------------------

function run_task(tasktype::AbstractString)
    if tasktype == "sum_even"
        return run_sum_even()
    elseif tasktype == "count_vowels"
        return run_count_vowels()
    else
        return false, 0, 0, ["Unknown tasktype=$(tasktype)."]
    end
end

# Sample task: sum of even integers in a vector
function run_sum_even()
    feedback = String[]
    total = 0
    passed = 0

    if !isdefined(Main, :solve)
        push!(feedback, "Task file must define function `solve(xs)`.")
        return false, 0, 0, feedback
    end

    # Visible tests (students see these in the prompt)
    vis = [
        (Int[], 0),
        ([1,2,3,4], 6),
        ([2,2,2], 6),
        ([-2, -1, 0, 1, 2], 0),
    ]

    for (inp, exp) in vis
        total += 1
        try
            out = Main.solve(inp)
            @require(out == exp, "Expected $(exp) for input $(inp), got $(out)")
            passed += 1
        catch e
            push!(feedback, sprint(showerror, e))
        end
    end

    # Hidden tests (randomized but deterministic given secret & taskid)
    # We don't depend on external RNG packages; use Base.Random with a seeded MersenneTwister
    seed = foldl(+, codeunits(get(ENV, "TASK_SECRET", "CHANGE_ME_EACH_LECTURE") * get(ENV, "TASK_ID", "L8Q1")))
    rng = MersenneTwister(seed)
    for _ in 1:6
        n = rand(rng, 0:20)
        xs = [rand(rng, -50:50) for _ in 1:n]
        exp = sum(x for x in xs if iseven(x))
        total += 1
        try
            out = Main.solve(xs)
            @require(out == exp, "Hidden test failed for input of length $(n)")
            passed += 1
        catch e
            push!(feedback, "Hidden: " * sprint(showerror, e))
        end
    end

    return passed == total, passed, total, feedback
end

    # String task: count vowels (A/E/I/O/U, case-insensitive) in a given string
    function run_count_vowels()
        feedback = String[]
        total = 0
        passed = 0

        if !isdefined(Main, :solve)
            push!(feedback, "Task file must define function `solve(s::AbstractString)` returning Int.")
            return false, 0, 0, feedback
        end

        # Visible tests
        vis = [
            ("", 0),
            ("abc", 1),
            ("AEIOU", 5),
            ("Julia", 3),
            ("Psychology", 3), # y is not considered a vowel here
        ]

        for (inp, exp) in vis
            total += 1
            try
                out = Main.solve(inp)
                @require(out == exp, "Expected $(exp) for input \"$(inp)\", got $(out)")
                passed += 1
            catch e
                push!(feedback, sprint(showerror, e))
            end
        end

        # Hidden randomized tests
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
                out = Main.solve(s)
                @require(out == exp, "Hidden test failed for random string of length $(n)")
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

    # Expose secret/taskid to hidden tests via ENV too (so they don't appear in ARGS list)
    ENV["TASK_SECRET"] = args.secret
    ENV["TASK_ID"] = args.taskid

    # Load student task file (defines `solve`)
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

abspath(PROGRAM_FILE) == @__FILE__ && main()
