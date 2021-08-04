### Priority queues, heaps, and back to sorting.




```julia
using Random, DataStructures
Random.seed!(0)


function heap_sort!(array::AbstractArray)
    h = BinaryMinHeap{eltype(array)}()
    for e in array
        push!(h, e)
    end
    return extract_all!(h)
end

data = [65, 51, 32, 12, 23, 84, 68, 1]
heap_sort!(data)
```

Now some benchmarks:

```julia
Random.seed!(0)

data = rand(Int64,10^6)

n_range = 10^4:10^4:10^6 
times_heap_sort = Vector{Float64}(undef,0)

for n in n_range
    start_time = time_ns()
     (data[1:n]) 
    end_time = time_ns()
    push!(times_heap_sort, Int(end_time - start_time)/10^6) #time in milliseconds
end

plot(n_range,times_heap_sort, c = :red, label="heap sort (spikes due to GC)")
```

QQQQ - discuss memory management of heap sort and memory in general.

```julia
Random.seed!(0)
data = rand(Int64,10^6)
@time heap_sort!(data);
```

```julia
Random.seed!(0)
data = rand(Int64,10^6)
@time sort!(data);
```


QQQQ - so there is memory allocation and GC taking place. Let's see without GC:

```julia
Random.seed!(0)

data = rand(Int64,10^6)

n_range = 10^4:10^4:10^6 
times_heap_sort = Vector{Float64}(undef,0)

GC.enable(false) 
for n in n_range
    start_time = time_ns()
     (data[1:n]) 
    end_time = time_ns()
    push!(times_heap_sort, Int(end_time - start_time)/10^6) #time in milliseconds
end
GC.enable(true)

plot(n_range,times_heap_sort, c = :red, label="heap sort (spikes due to GC)")
```



```julia
using Random, Plots
Random.seed!(0)

data = rand(Int64,10^6)

n_range = 10^4:10^4:10^6 
times_heap_sort = Vector{Float64}(undef,0)
times_in_built_sort = Vector{Float64}(undef,0)

GC.enable(false) 
for n in n_range
    start_time = time_ns()
    heap_sort!(data[1:n]) 
    end_time = time_ns()
    push!(times_heap_sort, Int(end_time - start_time)/10^6) #time in milliseconds
    
    start_time = time_ns()
    sort!(data[1:n]) 
    end_time = time_ns()
    push!(times_in_built_sort, Int(end_time - start_time)/10^6) #time in milliseconds
end
GC.enable(true)

plot(n_range,times_heap_sort, label="heap sort")
plot!(n_range,times_in_built_sort, label = "in-built sort",
    xlabel="n", ylabel="Sorting time (ms)")
```




* Overview of complexity classes (just mention NP completeness).
* Example of searching through an arbitrary list/array vs. a sorted array... O(n) vs. O(log n)



## More tools

We now spend more time on "tools", namely,

* Unix command line
* Git and GitHub 
* The Visual Studio Code IDE

### Unix command line

An [operating system](https://en.wikipedia.org/wiki/Operating_system) is software that manages the other software and hardware of the computer. It manages:

* Files
* Computer memory (RAM)
* Running programms, processes (tasks), and sometimes threads within a task
* Input/Output
* Networking
* More ...

This includes low level interfaces between the running programs and hardware, as well as its own "programs" for interfacing and managining the system (e.g. graphical user interface for files, and importantly for us the **shell**).

[Unix](https://en.wikipedia.org/wiki/Unix) is a classic operating system still very much in use today. Mac's operating system [macOS](https://en.wikipedia.org/wiki/MacOS) is based on Unix. Similarly, [Linux](https://en.wikipedia.org/wiki/Linux) is a Unix based system. The most popular desktop family of operating systems, [Windows](https://en.wikipedia.org/wiki/Microsoft_Windows) is not Unix based.

Our focus is on the **shell**, or **command line interace** which allows to execute simple and complicated tasks via command line. In Windows this is called the "command line". You can watch this (one of many) [video tutorial series](https://www.youtube.com/watch?v=MBBWVgE0ewk&list=PL6gx4Cwl9DGDV6SnbINlVUd0o2xT4JbMu) about the windows command line. However, you are not required to build up "command line" knoweldge as as part of this course. Instead if you are a Windows user, we recommended you use [GitBash](https://gitforwindows.org/) which gives you "Unix command line emulation". If you are a Mac user, you will simply run "Terminal", and on Linux you will run "Shell".

Note that when you run a Julia REPL, hitting `;` puts you in "shell mode" where the sytem's default shell is present. 

We won't become shell experts but only learn to carry out a few basic tasks. Our main usecase will be using Git source control software (see more below). For this, we'll also learn about basic file manipulation commands and a few more tid bits will appear as needed. We assume you are familiar with the fact your system has files, and folders (directories). Here are more things to be aware of:

* `~` stands for the folder of your user.
* `/` stands for the root directory.
* `.` stands for the current directory (there is always the notion of the current directory for our process/program).
* `..` stands for the parent directory.

Key file navigation commands are:

* `ls` show files.
* `cd` change current directory.
* `pwd` print working directory.

Key file manipulation commands are (be careful!):

* `rm` remove.
* `rmdir`remove (empty directory).
* `cp` copy.
* `mv` move (also rename).

A few more usefull commands (apps):
* `echo` print to screen (can be used as part of a shell script).
* `cat` print a text file.
* `grep` search within a file.
* ...

Commands work well with wildcards/regular expressions. A very common one is `*`.  

Output of commands can be **piped** into other commands using `|`, similary it can be redirectred into file with `>` or `>>` for appending.

There are some commands dealing with users and permissions (we won't cover unless needed):

* `chmod` change permissions of a file.
* `whoami` who you are just in case you aren't sure.
* `sudo` super user do. 

There are some commands dealing with processes:

* `kill` a process.
* `ps` see running processes.

### Git and GitHub

Working with software requires keeping track of versions and modifications. For this there is a set of best working practices that often depend on the task at hand. 

One very useful tool is [Git](https://en.wikipedia.org/wiki/Git). We will be using Git both via command line and via Visual Studio Code. Git interfaces with online platforms such as [GitHub](https://en.wikipedia.org/wiki/GitHub) and [GitLab](https://en.wikipedia.org/wiki/GitLab). You may use GUI based applications for GitHub, such as [GitHub Desktop](https://desktop.github.com/), however to get some practice both with Git, and unix command line we'll use Git via the command line.

We'll demonstrate how to do the following:

* Create a GitHub repo.
* Clone it locally.
* Make changes and commit.
* Push to remote.

### Visual Studio Code (an IDE)

