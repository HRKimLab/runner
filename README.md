# runner
Runner enables you to run a Matlab code from multiple computers accessing a network shared folder. For now, it's not very user-friendly and you may need to look at the code a bit to use it in your environment.

# Situation
Cluster is cool, but a little bit technical. So you want to run your Matlab code in a multiple computers easily, but want to keep your code the same. And your lab is using a network shared folder. 

# How it works
- Runner watches a network shared folders and run a matlab codes that resides in the folder. (e.g, MachineName1/)
- dispatcher copies a function to folders that are monitored by individual machines.

# programs
- Runner: you open Matlab and run Runner in the computer
- run_monitor: monitoring program that you can see what is happening in each machine.
- run_* : example codes that runs in Runner
