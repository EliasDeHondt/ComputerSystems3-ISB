#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import *

__description__ = "Graphical Traceroute Script"
__output__ = "traceroute_graph.svg"  # The output file for the graph

print("##### " + __description__ + " #####") # Print the description
res, unans = traceroute(["www.kdg.be"], dport=[80, 443], maxttl=20, retry=-2) # Perform a traceroute to the specified website (e.g., kdg.be)
res.graph(target=__output__) # Generate a graphical output of the traceroute result
print(f"Graphical traceroute saved as {__output__}")