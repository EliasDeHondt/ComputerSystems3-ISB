#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 24/10/2024        #
############################
import subprocess

def check_services():
    http = subprocess.run(["systemctl", "is-active", "apache2"], capture_output=True)
    ssh = subprocess.run(["systemctl", "is-active", "ssh"], capture_output=True)
    # https = subprocess.run(["systemctl", "is-active", "nginx"], capture_output=True)
    # ftp = subprocess.run(["systemctl", "is-active", "vsftpd"], capture_output=True)
    # mysql = subprocess.run(["systemctl", "is-active", "mysql"], capture_output=True)
    # postgres = subprocess.run(["systemctl", "is-active", "postgresql"], capture_output=True)
    # dns = subprocess.run(["systemctl", "is-active", "bind9"], capture_output=True)
    # mail = subprocess.run(["systemctl", "is-active", "postfix"], capture_output=True)
    # ldap = subprocess.run(["systemctl", "is-active", "slapd"], capture_output=True)
    # ...

    if http.returncode == 0 and ssh.returncode == 0:
        print("OK")
        exit(0)
    elif http.returncode == 0 and ssh.returncode != 0:
        print("WARNING")
        exit(1)
    else:
        print("CRITICAL")
        exit(2)

if __name__ == "__main__":
    check_services()