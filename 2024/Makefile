.PHONY: course
course:
	julia --project=. src/makeCourse.jl

.PHONY: assessment
assessment:
	julia --project=. src/makeAssessments.jl

.PHONY: install
install:
	julia --project=. -e 'using Pkg; Pkg.instantiate()'
