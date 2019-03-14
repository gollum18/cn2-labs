# create a simulator object
set ns [new Simulator]

# turn on tracing
set nf [open q1.nam w]
$ns namtrace-all $nf

# define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam -a q1.nam &
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

# get the delay components of the links
set send_link [$ns link $a1 $p]
set carrier_link [$ns link $p $q]
set reply_link [$ns link $q $b1]

# setup the queue limit
$ns queue-limit $a1 $p 10
$ns queue-limit $p $q 10
$ns queue-limit $q $b1 10

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
for {set i 1} {$i < 11} {incr i} {
    # send_link, carrier_link, reply_link
    $ns at $i*2 "$send_link set delay_ [expr $i*2]ms"
    $ns at $i*2 "$carrier_link set delay_ [expr $i*2]ms"
    $ns at $i*2 "$reply_link set delay_ [expr $i*2]ms"
}

# call finish after 20 seconds of sim time
$ns at 20 "finish"

# run the simulation
$ns run
