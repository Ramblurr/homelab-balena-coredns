##
# Project Title
#
# @file
# @version 0.1



# end

COREDNS_VERSION ?= 1.8.0

fetch:
	wget -c "https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_arm.tgz"
	rm coredns
	tar zxvf coredns_${COREDNS_VERSION}_linux_arm.tgz
	rm coredns_${COREDNS_VERSION}_linux_arm.tgz
