# VoipQosTrafficShaping_using_tc

VoIP (Voice over IP) is extremely sensitive to latency, jitter and packet loss.

QoS (Quality of Service) is used to prioritize VoIP traffic over less important data (like large downloads), reserve bandwidth and ensure consistent delivery.

The following script creates two classes: VoIP high priority (1:10), bulk data low priority (1:12). It will also add filters to match UDP (VoIP-like) traffic to the high-priority class.
