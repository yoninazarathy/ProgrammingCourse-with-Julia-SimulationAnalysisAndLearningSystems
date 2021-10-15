using Weave
cd(@__DIR__)
using Pkg; Pkg.activate("..")
cd("..")


kwargs_uc = (doctype = "md2html", out_path = "lectures_html", template = "math2504_under_const.tpl", mod = Main) #for "under construction
kwargs_publish = (doctype = "md2html", out_path = "lectures_html", template = "math2504.tpl", mod = Main) 


# weave("markdown/lecture-unit-1.jmd"; kwargs_publish...)
# weave("markdown/lecture-unit-2.jmd"; kwargs_publish...)
# weave("markdown/lecture-unit-3.jmd"; kwargs_publish...)
# weave("markdown/lecture-unit-4.jmd"; kwargs_publish...) 
# This unit is not on weave:  weave("markdown/lecture-unit-5.jmd"; kwargs_uc...) 
weave("markdown/lecture-unit-6.jmd"; kwargs_publish...) 
# weave("markdown/lecture-unit-7.jmd"; kwargs_publish...) 