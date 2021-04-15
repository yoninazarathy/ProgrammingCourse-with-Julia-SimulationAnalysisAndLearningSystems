using Weave
cd(@__DIR__)
cd("..")

weave("markdown/lecture-unit-1.jmd"; doctype = "md2html", out_path = "html")
weave("markdown/lecture-unit-2.jmd"; doctype = "md2html", out_path = "html")
weave("markdown/lecture-unit-3.jmd"; doctype = "md2html", out_path = "html")
weave("markdown/lecture-unit-4.jmd"; doctype = "md2html", out_path = "html") 