# runner

Runner enables you to run a Matlab code from multiple computers accessing a network shared folder. 

# Situation
Cluster is cool, but a little bit technical. You want to run your Matlab code in a multiple computers easily, but want to keep your code the same. Your lab is using a network shared folder and some fast computers are idle at night after experiments. So you want to use these computers, but remote desktop is restricted or it's too much to run the code individually in many computers. 

# How it works
- Runner watches a network shared folders and run a matlab codes sequentially in the folder. (e.g, MachineName1/)
- dispatcher copies a function to folders that are monitored by individual machines. Or you can just manually copy it.

# programs
- Runner: you open Matlab and run Runner in the computer
- run_monitor: monitoring program that you can see what is happening in each machine.
- run_* : example codes that runs in Runner
