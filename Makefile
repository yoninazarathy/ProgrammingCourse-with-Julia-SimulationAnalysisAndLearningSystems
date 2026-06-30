.PHONY: install
install:
	julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Individual lecture targets
.PHONY: lecture-1 lecture-2 lecture-3 lecture-4 lecture-5 lecture-6 lecture-7 lecture-8
lecture-1:
	quarto render quarto/lecture-unit-1.qmd --to html,pdf
lecture-2:
	quarto render quarto/lecture-unit-2.qmd --to html,pdf
lecture-3:
	quarto render quarto/lecture-unit-3.qmd --to html,pdf
lecture-4:
	quarto render quarto/lecture-unit-4.qmd --to html,pdf
lecture-5:
	quarto render quarto/lecture-unit-5.qmd --to html,pdf
lecture-6:
	quarto render quarto/lecture-unit-6.qmd --to html,pdf
lecture-7:
	quarto render quarto/lecture-unit-7.qmd --to html,pdf
lecture-8:
	quarto render quarto/lecture-unit-8.qmd --to html,pdf

# Individual assessment targets
.PHONY: assessment-bighw assessment-project3 assessment-projectA assessment-projectB
assessment-bighw:
	quarto render quarto/Assessment/bighw.qmd --to html,pdf
assessment-project3:
	quarto render quarto/Assessment/project3.qmd --to html,pdf
assessment-projectA:
	quarto render quarto/Assessment/projectA.qmd --to html,pdf
assessment-projectB:
	quarto render quarto/Assessment/projectB.qmd --to html,pdf

# Combined targets
.PHONY: all-lectures
all-lectures: lecture-1 lecture-2 lecture-3 lecture-4 lecture-5 lecture-6 lecture-7 lecture-8

.PHONY: all-assessments
all-assessments: assessment-bighw assessment-project3 assessment-projectA assessment-projectB

.PHONY: quarto-render
quarto-render: all-lectures all-assessments

.PHONY: quarto-html
quarto-html:
	quarto render quarto/ --to html

.PHONY: quarto-pdf
quarto-pdf:
	quarto render quarto/ --to pdf

.PHONY: quarto-clean
quarto-clean:
	rm -rf quarto/_freeze quarto/.quarto lectures_html_pdf/quarto
