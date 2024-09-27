#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 27/09/2024        #
############################
from http.server import BaseHTTPRequestHandler, HTTPServer
import time

hostName = "localhost"
hostPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>Titel</title></head>", "utf-8"))
        self.wfile.write(bytes("<body><p>Dit is een test.</p>", "utf-8"))
        self.wfile.write(bytes("<p>You accessed path: %s</p>" % self.path, "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))

myServer = HTTPServer((hostName, hostPort), MyServer)
print(time.asctime(), "Server Starts - %s:%s" % (hostName, hostPort))

try:
    myServer.serve_forever()
except KeyboardInterrupt:
    pass

myServer.server_close()
print(time.asctime(), "Server Stops - %s:%s" % (hostName, hostPort))