using Weave
cd(@__DIR__)
using Pkg; Pkg.activate("..")
cd("..")

kwargs = (doctype = "md2html", out_path = "assessment_html", template = "math2504assessment.tpl")

assesmentSubfolder = "2023Assessment"

# weave("markdown/$(assesmentSubfolder)/bighw.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/project1.jmd"; kwargs...)
weave("markdown/$(assesmentSubfolder)/project2.jmd"; kwargs...)
# weave("markdown/$(assesmentSubfolder)/project3.jmd"; kwargs...)#


### This is a temporary hack to add links to question numbers (it assumes questions are heading 2's)
q = 0
lines = readlines("assessment_html/bighw.html"; keep=true)

for (i, line) in enumerate(lines)
    if contains(line, "<h2>")
        global q = q + 1
        lines[i] = replace(line, "<h2>" => "<h2 id=q$q>")
    end
end

open("assessment_html/bighw.html", "w") do f
    for line in lines
        write(f, line)
    end
end
