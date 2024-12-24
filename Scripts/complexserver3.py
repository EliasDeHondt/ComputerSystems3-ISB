#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 27/09/2024        #
############################
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import mimetypes
import psutil
import os
import easygui
import subprocess

hostName = "0.0.0.0"
hostPort = 1234

class MyServer(BaseHTTPRequestHandler):
    server_instance = None  # Class variable to store the server instance

    @classmethod
    def set_server_instance(cls, server):
        cls.server_instance = server  # Set the server instance

    def get_apache_status(self):
        """Retrieve the status of the Apache server."""
        try:
            result = subprocess.run(["systemctl", "status", "apache2"], capture_output=True, text=True)
            if result.returncode == 0:
                return result.stdout
            else:
                return "Apache status could not be retrieved."
        except Exception as e:
            return f"Error retrieving status: {str(e)}"

    def do_GET(self):
        if self.client_address[0] != "127.0.0.1":
            self.send_response(404)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(b"<h1>404 Not Found</h1>")
            return
        else:
            if self.path == "/ps.cgi":
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(b"<h1>Process List</h1>")
                for process in psutil.process_iter():
                    self.wfile.write(f"<p>{process}</p>".encode("utf-8"))
                return
            if self.path == "/filelist.cgi":
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(b"<h1>File List</h1>")
                for file in os.listdir("/var/www"):
                    self.wfile.write(f"<p>{file}</p>".encode("utf-8"))
                return
            if self.path == "/gui.cgi":
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(b"<h1>GUI</h1>")
                
                # Fetch the Apache status
                apache_status = self.get_apache_status()

                choice = easygui.buttonbox("Choose an option", "Server Control", ["Start", "Stop", "Exit", "Check Apache Status"])
                if choice == "Start":
                    self.wfile.write(b"<script>alert('If you press this button, the server is already active. :)');</script>")
                elif choice == "Stop":
                    self.wfile.write(b"<script>alert('Stopping the server...');</script>")
                    self.server_instance.shutdown()  # Gracefully shutdown the server
                    os._exit(0)  # Forcefully exit the entire Python process
                elif choice == "Check Apache Status":
                    easygui.msgbox(apache_status, title="Apache Status")
                elif choice == "Exit":
                    self.wfile.write(b"<script>window.close();</script>")

                return
            else:
                self.send_response(200)
                mimetype, _ = mimetypes.guess_type(self.path)
                self.send_header("Content-type", mimetype)
                self.end_headers()
                with open("/var/www" + self.path, "rb") as file:
                    self.wfile.write(file.read())

myServer = HTTPServer((hostName, hostPort), MyServer)
MyServer.set_server_instance(myServer)
print(time.asctime(), "Server Starts - %s:%s" % (hostName, hostPort))

try:
    myServer.serve_forever()
except KeyboardInterrupt:
    pass

myServer.server_close()
print(time.asctime(), "Server Stops - %s:%s" % (hostName, hostPort))