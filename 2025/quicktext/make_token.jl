#!/usr/bin/env julia
# Compute expected token for manual verification
# Usage:
#   julia quicktext/make_token.jl SECRET TASKID UQID
using SHA

function token(secret, taskid, uqid)
    hex = uppercase(bytes2hex(sha1(string(secret, "|", taskid, "|", uqid, "|PASS"))))
    return first(hex, 6)
end

if length(ARGS) != 3
    println("Usage: julia quicktext/make_token.jl SECRET TASKID UQID")
    exit(1)
end
println(token(ARGS[1], ARGS[2], ARGS[3]))
