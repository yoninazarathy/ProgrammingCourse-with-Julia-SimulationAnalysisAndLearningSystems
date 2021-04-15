using Weave
cd(@__DIR__)
cd("..")

kwargs = (doctype = "md2html", out_path = "html", template = "math2504.tpl")

weave("markdown/lecture-unit-1.jmd"; kwargs...)
weave("markdown/lecture-unit-2.jmd"; kwargs...)
weave("markdown/lecture-unit-3.jmd"; kwargs...)
weave("markdown/lecture-unit-4.jmd"; kwargs...) 
weave("markdown/lecture-unit-5.jmd"; kwargs...) 
weave("markdown/lecture-unit-6.jmd"; kwargs...) 
weave("markdown/lecture-unit-7.jmd"; kwargs...) 