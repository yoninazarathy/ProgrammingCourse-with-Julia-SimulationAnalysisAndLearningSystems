# Project \#2 - Semester 2, 2021
# Discrete Event Simulation (+ perspective seminar summary)

(last edit: Oct 4, 2021)

**Here is an [explainer video for the project](https://youtu.be/dVf-Ss7tq-A)**.

**Due:** End of Day, Friday, 22, October, 2021. Late submissions are not accepted. **Work in pairs**. You must let the course coordinator know who your partner is. (Note: The course profile states submission a week earlier than Oct 22, but this is a mistake).

**Note:** The teaching staff will only answer questions (via Piazza, consultation hour, or practicals) regarding this assignment up to the late evening of Wednesday 20/10.

**Weights and marking criteria:** Total number of points: **100**. There are **10** points for handing in according to the hand-in instructions, including a voice recording, neat output, and very importantly the GitHub repo. There are **10** points for the summary of Anna Foeglein's perspective seminar. The remaining **80** points are for the project with more details to be updated.

**Submission format:** This project should be submitted via a GitHub Repo, a PDF file, and a voice recording via Blackboard. 

Specific instructions for the GitHub repo are below. It is important that the GitHub repo be made **private** and the course user name `uqMATH2504` be invited as a collaborator. 

The PDF file should be a nice formatted file that has:

* Your names, student numbers, and assignment title (Project 2 - 2021) on the top.
* A (clickable) link to your GitHub repo.
* Summaries as instructed below.

The recommended way to make the PDF file is via a Jupyter notebook where you copy in some code and output into the notebook, and in certain cases use `include()` to run Julia code if appropriate. You also comment on questions in this PDF (e.g. when asked to answer things not via code). If desired you could keep this jupyter notebook (`.ipynb` file) in the repo. However, this Jupyter notebook will not be checked (only the PDF file), and it isn't required to be a "runnable" notebook. In any case, please avoid pixilated screenshots of code, so for example if you choose to format your PDF file in MS-word (instead of Jupyter), make sure the code is clean, formatted, and readable. 

Marking responses will be made by the teaching staff by annotating **selected parts** of your PDF file via blackboard. Hence a very readable and clean PDF file is important. Note that in printing Jupyter to PDF (or exporting to PDF) there may sometimes be excessive white space. Do not worry about this extra white space; it is not a problem.

**Work in pairs**: This is work in pairs. Plagiarism between groups will not be accepted. Nevertheless, feel free to consult with friends or classmates via Piazza and other means about how to go about certain tasks.

**Marking Criteria**: 

* 10 points are allocated for following instructions and the GitHub repo.

* 10 points are allocated to the summary of the perspective seminar. 2 points for coherent and grammatically correct writing. 6 points for completeness (the writeup should answer all questions posed). 2 points of originality and style.

* 80 points are for the simulation project itself. 60 of the points are allocated for correctness of the results (20 for each of the plot types specified below). 20 points are allocated for style, design, code organization, and neatness/sensibility of the output.

* In general, points **will be** deducted for sloppy coding style. Make sure to have your code properly indented, to use sensible and consistent variable names, and to write code that is in general clean and consistent. 

---

## Setting up your GitHub repo for hand-in (10pts):

* Ideally use the same accounts you used for PROJECT1 and HW1. Choose one of the team members to "own" the repo and the other(s) will be invited as collaborators.  
* Create a new repo for this assignment. Name the repo exactly as `<<FIRST NAME1>>-<<LAST NAME1>>-and-<<FIRST NAME2>>-<<LAST NAME2>>-2504-2021-PROJECT2`. So for example if your names are "Jeannette Young" and "Julia Gillard", the repo name should be `Jeannette-Young-and-Julia-Gillard-2504-2021-PROJECT2`.
* Make sure the repo is **private**.
* Invite the course GitHub user, `uqMATH2504` as a collaborator. You may do so early on while working on the project, and must do this no later than the project due date.
* Do **not** make any changes (commits) to the repo after the project due date. 
* Create a local clone of the repo. It is recommended that use use `git` command line via the shell to work on making changes/additions to the assignment and submitting the changes. However you are free to use any other mechanism (VS-Code, GitHub desktop, etc).
* If for some reason you are not able or willing ot use GitHub an alternative is GitLab. This is not recommended as it adds additional work to the teaching staff, however if you wish to use GitLab instead of GitHub contact the teaching staff for permission.

Your GitHub repo should be formatted as exactly as follows:
* Have a `README.md` file which states your names, the assignment title, and has a (clickable) link to the assignment instructions on the course website (to this document). 
* Have a `LICENSE.md` file. Choose a license as you wish (for example the MIT license). However keep in mind that you must keep the submission private until the end of the semester.
* Have a `.gitignore` file. 
* Have basic running instructions on how to run the code. This can be similar to what was provided for Project 1 (polynomials). 
* Have `src` and `test` folders similarly to Project 1.
* Note: make sure that there aren't any files in your submission repo except for those mentioned above (with the exception of perhaps a Jupyter `.ipynb` file if you choose to use it for creating the PDF). Use may use the `.gitignore` file to ensure `git` does not commit additional files and output files to your `repo`.

Since this project involves work in pairs, it is recommended that you try to use GitHub effectively. You may work on parallel branches with frequent merges, or work on the same branch via peer programming. The way you develop is not being assessed, still it is recommended you make good use of GitHub.

## Perspective seminar question (10pts)

Write a 1-4 paragraph summary of Anna Foeglein's perspective seminar. The writeup should answer these questions without treating the questions directly. That is, don't write "the answer to Q1 is..." etc. Instead incorporate the answers in a flowing writeup report (like a blog post or letter). You may use first person, or similar. Present the writeup as part of your PDF file submission (as the first item in the submission).

The writeup should address the following questions:

1. What was Anna's career path, and her relationship with software and mathematics?
1. Where does she currently work? What does she do in her job? How do you perceive her personal experience from her job?
1. Discuss a few key tools that she spoke about during the talk, such as programming languages, mathematics, machine learning, statistical tools, simulation platforms, and the like. Was this the first time that you heard about any of these tools?
1. Have you picked up any tips from Anna's talk, which you can perhaps use in your career down the road?
1. Feel free to state anything else that you found interesting from the talk and to contrast this talk with the previous talk.

Note: Since the submission is in pairs you should only submit a single writeup for the pair/group.

## Main project task (80pts)

Your task is to create a discrete event simulation engine that simulates a complex queueing network system/model. As a very rough motivational example consider an amusement park (e.g. [Dream World](https://www.dreamworld.com.au/)). There are multiple rides and individuals move throughout the park and queue up for rides. After they finish a ride they walk to a different ride and so-fourth. However, this is just a rough motivation and there are several significant differences between the model you will simulate and what may constitute something like an amusement park. Below is a detailed mathematical description of the model.

In your queueing simulation model there are $L$ stations (e.g. $L=5$ or $L=100$) and each station has a  **server** and a **waiting buffer**. There are jobs traversing through the network and the stations. Jobs can be numbered $\ell=1,2,3,\ldots$ and it is expected that the simulation processes thousands, or millions of jobs. 

A job's location can be one of:

* Out the system prior to arrival (still doesn't exist).
* In the system in a buffer of one of the stations (queueing).
* In the system being served by one of the stations.
* In the system currently moving between stations.
* Out of the system after leaving.

In this continuous time system, jobs arrive to the system according to a random process (see distributional specification below) and traverse between the stations as we describe now.

Each station $i=1,\ldots,L$ has a service rate $\mu_i > 0$ which is the inverse of the mean expected time it takes the server to process a job. It also has a buffer capacity $K_i$ which implies the number of jobs that can queue in the buffer. The capacity $K_i$ is a non-negative integer or can be $\infty$.

When a job arrives to station $i$, if the server is free (and this means there are no jobs in the buffer), the job immediately begins service from the server. If the server is busy and there is waiting room in the buffer, the job queues for service. However if the buffer is full (the current jobs waiting in the buffer is equal to $K_i$), the job does not enter the buffer and moves according to an **overflow rule** (these rules are described below).

Durations of events follow independent random variables. These include

* Durations between times of external arrivals. The external rate of arrivals is $\lambda > 0$, so the mean duration between arrivals is $1/\lambda$.
* Durations of service times. As stated above the mean is $1/\mu_i$.
* Duration of time moving between stations when overflowing. The mean time is $1/\eta$, fixed for all stations.
* Duration of time moving between stations after service. The mean is again $1/\eta$.

All of these durations are gamma distributed with a ratio of the mean and variance (squared coefficient of variation) equal to $3$. Hence the parameters for durations are $\lambda$, $\eta$, and $\mu_1,\ldots,\mu_L$.

When a job completes service at a buffer it either leaves the system immediately, or moves to another buffer. The choice of its destination is based on the routing matrix $P$. Here $P_{i,j}$ is probability of going to station j after completing service in station $i$.  It is assumed that $P$ has non-negative entries and has a spectral radius less than $1$. Mathematically this means that the maximal absolute value of eigenvalues of $P$ is less than unity. The probability of a job leaving the system (immediately) after service at station $i$ is $1 - \sum_{j=1}^L P_{i,j}$.

When a job arrives to buffer $i$ that is full (has a job in service and has $K_i$ jobs waiting), it must overflow. This is done by going to a destination buffer $j$ (or leaving the system) based on the overflow matrix $Q$. Like $P$, the matrix $Q$ has non-negative entries with a maximal eigenvalue value less than unity. The probability of leaving the system (when overflowing from buffer $i$) is $1 - \sum_{j=1}^L Q_{i,j}$. In such a case the job leaves immediately. 

External arrivals decide which station to go to first based on a final input parameter vector $p^e$. This vector of length $L$ indicates the probability $p^e_i$ of an external arrival joining station $i$. When an external arrival joins the system it directly goes to that station and either enters (service or waiting) or overflows.

There are two main modes for this discrete event simulation:

1. Keeping track of all jobs.
1. Keeping track only of the number of jobs in each station (service and waiting buffer), and the number of jobs circulating between stations. 

Your simulation should support both modes. In the first mode only station statistics (and join station) statistics may be collected from a simulation run. In the second mode, individual job trajectories can be collected. 

You are given 5 different input parameter scenarios. These are described in the code below. Each of these scenarios specifies the "network structure" via the matrix $P$, the matrix $Q$, and the input arrivals spread $p^e$. It also specifies the service rates $\mu_i$. In each case take $\eta = 4.0$ and vary $\lambda$. In each run the simulation for a long horizon (eventually $T = 10e^7$).

Your goal is to vary $\lambda$ and simply create three plots for each scenario:

1. The mean number of items in the total system as a function of $\lambda$. 
1. The proportion of jobs that are in orbit (circulating between nodes) as a function of $\lambda$. 
1. The empirical distribution of the sojourn time of a job through the system (varied as a function of $\lambda$).

In each of these cases, simulate a long simulation path and assume the system is ergodic (this may actually not hold in certain cases since with too high of a $\lambda$ value the system may be unstable in certain cases). For each value of $\lambda$ over a grid, simulate and collect the results to be plotted.

Note that in your discrete event simulation you can assume that no two events happen in the same time. There is a small chance for that with floating point numbers (and continuos distributions) but it is low.

It is recommended that you use the code provided in the lecture and the tutorial for discrete event simulation as a general template. However, you may vary the code and the design of your project as you see fit. 


```julia
#Here are parameters for scenarios 1, 2, 3, 4, 5 for Project 2
#For convenience they are stored in a struct, NetworkParameters

using Parameters #You need to install the Parameters.jl package: https://github.com/mauro3/Parameters.jl 
using LinearAlgebra 

#The @with_kw macro comes from the Parameters package
@with_kw struct NetworkParameters
    L::Int
    gamma_shape::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 #This is undefined for the scenarios since it is varied
    η::Float64 #This is assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} #-1 means infinity 
end

############################
scenario1 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario1

############################
scenario2 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario2

############################
scenario3 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = [0 0.5 0;
                                     0 0 0.5;
                                     0.5 0 0],
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario3

############################
scenario4 = NetworkParameters(  L=5, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = collect(5:-1:1),
                                P = [0   0.5 0.5 0   0;
                                     0   0   0   1   0;
                                     0   0   0   0   1;
                                     0.5 0   0   0   0;
                                     0.2 0.2 0.2 0.2 0.2],
                                Q = [0 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0],                             
                                p_e = [0.2, 0.2, 0, 0, 0.6],
                                K = [-1, -1, 10, 10, 10])
@show scenario4

############################
scenario5 = NetworkParameters(  L=20, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(20),
                                P = zeros(20,20),
                                Q = diagm(3=>ones(19), -19=>ones(3)),                             
                                p_e = vcat(1,zeros(19)),
                                K = fill(5,20))
@show scenario5 
```