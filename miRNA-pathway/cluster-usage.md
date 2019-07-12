[TOC levels=1-3]: #

# Table of Contents
- [Table of Contents](#Table-of-Contents)
- [Name](#Name)
- [Introduction](#Introduction)
- [Schduling a job](#Schduling-a-job)
  - [Interactive jobs](#Interactive-jobs)
  - [Long time running jobs](#Long-time-running-jobs)
- [Saving interactive session (tmux)](#Saving-interactive-session-tmux)
- [Software usage](#Software-usage)

# Name
Cluster usage personal protocol - simple protocol of the Yale Farnam cluster for self usage

# [Introduction](https://docs.ycrc.yale.edu/clusters-at-yale/) 

Broadly speaking, a compute cluster is a collection of networked computers which we call nodes. Our clusters are only accessible to researchers remotely; your gateway to the cluster is the **login node**. From this node, you will be able to view your files and dispatch jobs to one or several other nodes across the cluster configured for computation, called **compute nodes**. The tool we use to submit these jobs is called a **job scheduler**. All compute nodes on a cluster mount a **shared filesystem**; a file server or set of servers that keeps track of all files on a large array of disks, so that you can access and edit your data from any compute node. 

# Schduling a job 
Attention! No job could be done in the login node, that will cause terrible results, therefore, specific job scheduling methods should be followed.

## Interactive jobs
To acquest a free node for the interactive jobs, we could use the following command in the login node:
```bash
srun --pty -p interactive bash
```

## Long time running jobs
`Slurm` is used to submit jobs to a specified set of compute resources, which are variously called queues or partitions.

The basic commands could be listed as following:
```bash
# submit a script
sbatch <script>

# list queued and running jobs
squeue -u $USER

# cancel a queued job or kill a running job
scancel <job_id>

# check status of individul job
sacct -j <job_id>
```

# Saving interactive session (tmux)
`tmux` is a "terminal multiplexer", it enables a number of terminals (or windows) to be accessed and controlled from a single terminal. 

**KEEP IN MIND:** the correct procedure binding `tmux` and cluster usage could be listed as following:

- ssh to the cluster of choice
- start tmux in the login node
- inside the tmux session, submit an interactive job with srun
- inside the job allocation(on a compute node), start the application node
- detach from `tmux` by typing `Ctrl` + `b` and the `d`
- on the name login node, reattach by running `tmux attach`

```bash
#Start new named session:
tmux new -s [session name]

#Detach from session:
ctrl+b d

#List sessions:
tmux ls

#Attach to named session:
tmux a -t [name of session]

#Kill named session:
tmux kill-session -t [name of session]

#Split panes horizontally:
ctrl+b "
#"

#Split panes vertically:
ctrl+b %

#Kill current pane:
ctrl+b x

#Move to another pane:
ctrl+b [arrow key]

#Cycle through panes:
ctrl+b o

#Cycle just between previous and current pane:
ctrl+b ;

#Kill tmux server, along with all sessions:
tmux kill-server
```

# Software usage
