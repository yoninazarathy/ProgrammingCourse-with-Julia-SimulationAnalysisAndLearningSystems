quick commands you can share
CSV task example (students):

julia quickgrader.jl --task quicktext/sample_task_sum_csv.jl --uqid s1234567 --taskid L8Q4 --secret L8_2025_10_28 --tasktype sum_csv
Or with the launcher script:

export TASK_SECRET=L8_2025_10_28
export TASK_ID=L8Q4
export TASK_TYPE=sum_csv
export UQID=s1234567
export TASK_FILE=quicktext/sample_task_sum_csv.jl
./quicktext/run_quickgrader.sh