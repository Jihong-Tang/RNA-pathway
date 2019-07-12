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

- 
# Saving interactive session (tmux)
`tmux` is a "terminal multiplexer", it enables a number of terminals (or windows) to be accessed and controlled from a single terminal. 

# Software usage