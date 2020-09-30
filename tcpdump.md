# TCPDUMP notes

## Preparation

	export host_A=<IP of host A>
	export host_B=<IP of host B>

## Filters

Capture all traffic between host `A` and host `B`, through the interface `ens33`.

	tcpdump -i ens33 host ${host_A} and host ${host_B}

Capture all traffic between host `A` and host `B`, on ports 5000 or 5001, through the interface `ens33`.

	tcpdump -i ens33 host ${host_A} and host ${host_B} \
		port 5000 or 5001

Capture all traffic emitted from host `A` in destinations to host `B`, through the interface `ens33`.

	tcpdump -i ens33 src host ${host_A} and dst host ${host_B}

Capture all TCP traffic emitted from host `A` in destinations to host `B`, through the interface `ens33`.

	tcpdump -i ens33 tcp and src host ${host_A} and dst host ${host_B}

Capture all TCP traffic emitted from host `A` in destinations to host `B`, through the interface `ens33`. We only keep the frames emitted _from the port 5001 to any port_, or _from any port to the port 5001_.

	tcpdump -i ens33 tcp and \
        port 5001 and \
        src host ${host_A} and \
        dst host ${host_B}

Capture all TCP traffic emitted from host `A` in destinations to host `B`, through the interface `ens33`. We only keep the frames emitted _from any port to the port 5001_.

	tcpdump -i ens33 tcp and \
        dst port 5001 and \
        src host ${host_A} and \
        dst host ${host_B}

OK, but I'd like to see the payload!

* `-s 0`: Setting snaplen to 0 sets it to the default of 262144.
* `-A`: Print each packet (minus its link level header) in ASCII. Handy for capturing web pages. 

Command:

	tcpdump -i ens33 \
        -s 0 \
        -A \
	    tcp and \
        dst port 5001 and \
        src host ${host_A} and \
        dst host ${host_B}

## Catching TCP connections ?

See [this document](https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Connection_establishment)

> * `SYN`: The active open is performed by the client sending a SYN to the server. The client sets the segment's sequence number to a random value A.
> * `SYN-ACK`: In response, the server replies with a SYN-ACK. The acknowledgment number is set to one more than the received sequence number i.e. A+1, and the sequence number that the server chooses for the packet is another random number, B.
> * `ACK`: Finally, the client sends an ACK back to the server. The sequence number is set to the received acknowledgement value i.e. A+1, and the acknowledgement number is set to one more than the received sequence number i.e. B+1.

Command:


	tcpdump -i ens33 \
        -s 0 \
        -A \
	    tcp and \
        host ${host_B}

Example:

	10:08:24.004628 IP host_A.56550 > host_B: Flags [S], seq 926272363, win 29200, options [mss 1460,sackOK,TS val 2977349867 ecr 0,nop,wscale 7], length 0
	...
	10:08:24.005074 IP host_B > host_A.56550: Flags [S.], seq 872474718, ack 926272364, win 28960, options [mss 1460,sackOK,TS val 580071031 ecr 2977349867,nop,wscale 7], length 0
	...
	10:08:24.005126 IP host_A.56550 > host_B: Flags [.], ack 1, win 229, options [nop,nop,TS val 2977349868 ecr 580071031], length 0
	...

The general format of a TCP protocol line is (see [the man page for tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html)): 

	src > dst: Flags [tcpflags], seq data-seqno, ack ackno, win window, urg urgent, options [opts], length len

From the manpage:

* `Flags [S]`: Syn
* `Flags [.]`: Ack
* `Flags [S.]`: Syn-Ack

Thus, we have the connection opening:

* The client sends a SYN to the server. The sequence number is `926272363`.
* In response, the server replies with a SYN-ACK. The acknowledgment number is set to one more than the received sequence number i.e. `A+1` = `926272363 + 1 = 926272364`. The server chooses another sequence number `872474718`. An the the acknowledgement number is `2977349867`.
* Finally, the client sends an ACK back to the server. The sequence number is set to the received acknowledgement value i.e. `A+1` = `2977349867 + 1 = 2977349868`.
