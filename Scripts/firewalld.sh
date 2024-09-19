#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 19/09/2024        #
############################

firewalld_stop() {
    iptables -F
    iptables -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
}

firewalld_start() {
    iptables -F
    iptables -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -p icmp -j DROP
    iptables -A OUTPUT -p icmp -j DROP
}

firewalld_restart() {
    firewalld_stop
    firewalld_start
}

firewalld_reload() {
    firewalld_stop
    firewalld_start
}

case "$1" in
    start)
        firewalld_start
        ;;
    stop)
        firewalld_stop
        ;;
    restart)
        firewalld_restart
        ;;
    reload)
        firewalld_reload
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload}"
        exit 1
        ;;
esac