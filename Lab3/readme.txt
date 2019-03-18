The NS scripts for the simulation are:
    q1.tcl and q2_sim.tcl

However to run the simulation for q2 properly, you must run q2.tcl.

q2.tcl is a bootstrap script that fires off six instances of Network Simulator with the target script q2_sim.tcl passing it the appropriate value of N. Try as I may, I was unable to get question 2 to work in just one script file. It seems that Network Simulator only allows one instance of a ns variable in any given script.

I tried creating a function for it, I tried forking (although thats not supported by default TCL so I scrapped it). The solution I have simulates all networks for the given values of N in question two in a reasonable fashion.

The python scripts q1.py and q2.py iterate over the resulting trace files and generate the plots that you requested. They utilize the third party library matlibplot to do so, so you must have it installed in your python installation if you want to run them.

The stuff for q1 will be placed in the root directory of where you extracted this zip to. However, the stuff generated for q2 will be placed in a separat folder 'q2'. Inside this folder you will find 6 folders each with a number as the folder name. These numbers are the values for N, and inside them you will find the appropriate output for each value of N.
