# create a simulator object
set ns [new Simulator]

# turn on tracing
set nf [open q1.nam w]
$ns namtrace-all $nf

# define a 'finish' procedure
proc finish {} {
    global ns nf tr_a1_p
    $ns flush-trace
    close $nf
    close $tr_a1_p
    exec python3 q1.py
    exit 0
}

# create the nodes
set a1 [$ns node]
set b1 [$ns node]
set p [$ns node]
set q [$ns node]

# create the links
$ns duplex-link $a1 $p 100Kb 15ms DropTail
$ns duplex-link $p $q 100Kb 15ms DropTail
$ns duplex-link $q $b1 100Kb 15ms DropTail

# get a reference to the links
set send_link [$ns link $a1 $p]
set carrier_link [$ns link $p $q]
set reply_link [$ns link $q $b1]

# setup the queue limit
$ns queue-limit $a1 $p 10
$ns queue-limit $p $q 10
$ns queue-limit $q $b1 10

# setup throughput tracing on the last hop link
set tr_a1_p [open "q1_a1_p.tr" w]
$ns trace-queue $a1 $p $tr_a1_p

# monitor the queues for the links
$ns duplex-link-op $p $q queuePos 0.5

# create the agents/sinks
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]

# set parameters of tcp
$tcp1 set fid_ 1
$ns color 1 blue

# set the parameters on the agent
$tcp1 set packetSize_ 1500
$tcp1 set maxcwnd_ 30
$ns attach-agent $a1 $tcp1

# attach the sink
$ns attach-agent $b1 $sink1

# connect the agent to the sink
$ns connect $tcp1 $sink1

# create and attach some tcp traffic generators
set exp1 [new Application/Traffic/Exponential]
$exp1 attach-agent $tcp1

# schedule events for the simulation
$ns at 1/10 "$exp1 start"

# schedule propagation delay updates
# link delay increase occur in steps of 2 ms from 2ms to 20ms
# each increase occurs at: 
# 1.75 3.5 5.25 7.0 8.75 10.5 12.25 14.0 15.75 17.5 seconds 
#   during the simulation
for {set i 1} {$i < 11} {incr i} {
    # send_link, carrier_link, reply_link
    $ns at [expr $i * 1.5 + $i * 0.25] "$send_link set delay_ [expr $i * 2]ms"
    $ns at [expr $i * 1.5 + $i * 0.25] "$carrier_link set delay_ [expr $i * 2]ms"
    $ns at [expr $i * 1.5 + $i * 0.25] "$reply_link set delay_ [expr $i * 2]ms"
}

# call finish after 20 seconds of sim time
$ns at 20 "finish"

# run the simulation
$ns run
