using Weave
cd(@__DIR__)
cd("..")

kwargs = (doctype = "md2html", out_path = "assessment_html", template = "math2504assessment.tpl")

assesmentSubfolder = "2021Assessment"

# weave("markdown/$(assesmentSubfolder)/hw1.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/hw2.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/project1.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/project2.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/project3.jmd"; kwargs...)#