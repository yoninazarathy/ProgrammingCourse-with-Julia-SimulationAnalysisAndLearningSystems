using Weave
cd(@__DIR__)
cd("..")

kwargs = (doctype = "md2html", out_path = "assessment_html", template = "math2504assessment.tpl")

assesmentSubfolder = "2021Assessment"

weave("markdown/$(assesmentSubfolder)/hw1.jmd"; kwargs...)
