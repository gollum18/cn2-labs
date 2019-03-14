set n [lindex $argv 0]

# create the simulator
variable ns [new Simulator]

# enable tracing
variable nf [open q2_$n.nam w]
$ns namtrace-all $nf

# create the gateway nodes
variable p [$ns node]
variable q [$ns node]

# create the traffic nodes
variable a {}
variable b {}
for {set i 0} {$i < $n} {incr i} {
    lappend a [$ns node]
    lappend b [$ns node]
}

# create the gateway link
$ns duplex-link $p $q 100Kb 15ms DropTail
$ns queue-limit $p $q 10

# create the traffic links
for {set i 0} {$i < $n} {incr i} {
    $ns duplex-link [lindex $a $i] $p 100Kb 15ms DropTail
    $ns queue-limit [lindex $a $i] $p 10
    $ns duplex-link [lindex $b $i] $q 100Kb 15ms DropTail
    $ns queue-limit [lindex $b $i] $q 10
}

# create the tcp agents/sinks
variable tcp {}
variable sink {}
for {set i 0} {$i < $n} {incr i} {
    # create the tcp agent
    lappend tcp [new Agent/TCP]
    [lindex $tcp $i] set packetSize_ 1500
    [lindex $tcp $i] set maxcwnd_ 30
    # create the corresponding sink agent
    lappend sink [new Agent/TCPSink]
    # attach the agent and sinks to their nodes
    $ns attach-agent [lindex $a $i] [lindex $tcp $i]
    $ns attach-agent [lindex $b $i] [lindex $sink $i]
    # connect the agent and sink
    $ns connect [lindex $tcp $i] [lindex $sink $i]
}

# create the traffic generators
variable traf {}
for {set i 0} {$i < $n} {incr i} {
    lappend traf [new Application/Traffic/Exponential]
    # TODO: Maybe randomize the traffic patterns?
    # attach the traffic source to the tcp agent
    [lindex $traf $i] attach-agent [lindex $tcp $i]
}

# schedule traffic
for {set i 0} {$i < $n} {incr i} {
    # tell the agent to start sending traffic at i/10 seconds
    $ns at $i/10 "[lindex $traf $i] start"
}

# schedule the finish 'proc'
$ns at 20 "$ns flush-trace"
$ns at 20 "close $nf"
$ns at 20 "exit 0"

# start the simulation
$ns run
