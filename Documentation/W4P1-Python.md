![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Python🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Basis webserver](#👉exercise-1-basis-webserver)
    3. [👉Exercise 2: Small modifications code](#👉exercise-2-small-modifications-code)
    4. [👉Exercise 3: Import mimetypes](#👉exercise-3-import-mimetypes)
    5. [👉Exercise 4: Check if the client is from localhost](#👉exercise-4-check-if-the-client-is-from-localhost)
    6. [👉Exercise 5: Install the psutil module](#👉exercise-5-install-the-psutil-module)
    7. [👉Exercise 6: Create a filelist with the files in the startup directory](#👉exercise-6-create-a-filelist-with-the-files-in-the-startup-directory)
    8. [👉Exercise 7: Create a simple graphical interface](#👉exercise-7-create-a-simple-graphical-interface)
    9. [👉Exercise 8: Get the status of Apache](#👉exercise-8-get-the-status-of-apache)
4. [⏱️Setup web server in one second](#⏱️setup-web-server-in-one-second)
5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. Basis webserver
    - Pas de Voorbeeldcode van de [Basisserver3](/Scripts/basisserver3.py) aan en start de webserver op als gewone gebruiker (neem poort 1234) met python3.
    - Test de webserver uit.

2. Voer nu achtereenvolgens volgende aanpassingen uit in de code:
    - Zorg ervoor dat je webserver draait op `127.0.0.1`
    - Zorg ervoor dat de webserver een `.html` bestand kan openen. Bv met the method "open".
    - Voorzie hiervoor bv het bestand `index.html`. Test uit met lynx `http://127.0.0.1:1234/index.html`

3. Een html bestand heeft als mimetype (en voor een browser als Content-type) text/html.
    - Gebruik nu "import mimetypes" om ook andere content dan HTML te voorzien.
    - Test uit met bv lynx `http://127.0.0.1:1234/index.txt` en lynx `http://127.0.0.1:1234/image.jpg`.

4. Kijk na of de client vanuit de localhost komt. Als dit niet het geval is geef je een 404 error boodschap.

5. Installeer als root de psutil module
    - Zorg nu dat je met behulp van deze module bij het oproepen van ps.cgi een proceslijst krijgt in je browser.

6. EXTRA: voorzie een filelist met de bestanden die in de opstartdirectory staan
    - Eenvoudige GUI:
        ```bash
        sudo apt-get install python3-easygui python3-pip
        pip3 install easygui
        ```
        - (Opgelet: noem je bestand niet `easygui.py`, want dan probeert hij bij een import easygui zichzelf te importeren)

7. Schrijf een eenvoudige grafische interface waarmee je de apache webserver kan starten en stoppen. BV met easygui buttonbox een knop start en stop en exit

8. Vraag de status op van apache en toon deze status als tekst in de buttonbox. BV de output van `systemctl status apache2 | grep Active`

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install python3-easygui python3-pip python3-venv lynx -y
```

- Create a virtual environment and install the necessary packages
```bash
python3 -m venv ~/my_venv
source ~/my_venv/bin/activate
pip3 install easygui
```

- If you want to leave the virtual environment, you can use the following command
```bash
deactivate
```

### 👉Exercise 1: Basis webserver

- In the file [basisserver3.py](/Scripts/basisserver3.py) you can find the basic webserver code.
```bash
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/basisserver3.py
```

- Modify the line `hostPort = 8080` to `hostPort = 1234`.
```bash
sed -i 's/hostPort = 8080/hostPort = 1234/g' basisserver3.py
```

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://localhost:1234
# Or
lynx http://127.0.0.1:1234
```

### 👉Exercise 2: Small modifications code

- Modify the line `hostName = "localhost"` to `hostName = "127.0.0.1"`.
```bash
sed -i 's/hostName = "localhost"/hostName = "127.0.0.1"/g' basisserver3.py
```

- To open an HTML document (`index.html`) instead of statically defining the HTML content, You need to modify the `class MyServer` as follows:
```python
class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        with open("/var/www/index.html", "r") as file:
            self.wfile.write(file.read().encode("utf-8"))
```

- Get the [index.html](/Html/index.html) file from the repository.
```bash
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Html/index.html
sudo mv index.html /var/www/index.html
```

- Run the webserver with the following command
```bash
sudo chmod 644 /var/www/index.html
sudo chmod 755 /var/www/
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://127.0.0.1:1234/index.html
```

### 👉Exercise 3: Import mimetypes

- Modify the `class MyServer` as follows:
```python
import mimetypes

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        mimetype, _ = mimetypes.guess_type(self.path)
        self.send_header("Content-type", mimetype)
        self.end_headers()
        with open("/var/www" + self.path, "rb") as file:
            self.wfile.write(file.read())
```

- For testing purposes, we will download an image in the web server directory.
```bash
curl -O https://eliasdh.com/assets/media/images/logo.png
sudo mv logo.png /var/www/eliasdh-logo.png
```

- Run the webserver with the following command
```bash
sudo chmod 644 /var/www/eliasdh-logo.png
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://127.0.0.1:1234/eliasdh-logo.png
```

> **NOTE:** (Optional) Like you probably noticed, the image is not displayed correctly. This is because the `lynx` browser does not support images. You can use an alternative tool to view the image.

- To view the image, you can use the `fim` tool.
```bash
sudo apt-get install fim -y # Install the fim tool
wget http://127.0.0.1:1234/eliasdh-logo.png -O eliasdh-logo.png # Download the image in the current directory
fim ./eliasdh-logo.png # View the image
rm eliasdh-logo.png # Remove the image
```

### 👉Exercise 4: Check if the client is from localhost

- Modify the line `hostName = "127.0.0.1"` to `hostName = "0.0.0.0"`.
```bash
sed -i 's/hostName = "127.0.0.1"/hostName = "0.0.0.0"/g' basisserver3.py
```

- Modify the `class MyServer` as follows:
```python
class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.client_address[0] != "127.0.0.1":
            self.send_response(404)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(b"<h1>404 Not Found</h1>")
            return
        else:
            self.send_response(200)
            mimetype, _ = mimetypes.guess_type(self.path)
            self.send_header("Content-type", mimetype)
            self.end_headers()
            with open("/var/www" + self.path, "rb") as file:
                self.wfile.write(file.read())
```

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://localhost:1234/index.html # This should work (200 OK)
# Or
lynx http://127.0.0.1:1234/index.html # This should work (200 OK)

# To make this work you need to expose your web server to external clients.
lynx http://192.168.1.210:1234/index.html # This should not work (404 Not Found) 
```

### 👉Exercise 5: Install the psutil module

- Install the `psutil` module with the following command
```bash
pip3 install psutil
```

- Modify the `class MyServer` as follows:
```python
import psutil

class MyServer(BaseHTTPRequestHandler):
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
            else:
                self.send_response(200)
                mimetype, _ = mimetypes.guess_type(self.path)
                self.send_header("Content-type", mimetype)
                self.end_headers()
                with open("/var/www" + self.path, "rb") as file:
                    self.wfile.write(file.read())
```

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://localhost:1234/ps.cgi
# Or
lynx http://127.0.0.1:1234/ps.cgi
```

### 👉Exercise 6: Create a filelist with the files in the startup directory

- Modify the `class MyServer` as follows:
```python
import os

class MyServer(BaseHTTPRequestHandler):
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
            else:
                self.send_response(200)
                mimetype, _ = mimetypes.guess_type(self.path)
                self.send_header("Content-type", mimetype)
                self.end_headers()
                with open("/var/www" + self.path, "rb") as file:
                    self.wfile.write(file.read())
```

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

- Open a new terminal and test the webserver with the following command
```bash
lynx http://localhost:1234/filelist.cgi
# Or
lynx http://127.0.0.1:1234/filelist.cgi
```

### 👉Exercise 7: Create a simple graphical interface

- Modify the `class MyServer` as follows:
```python
import easygui
import subprocess

class MyServer(BaseHTTPRequestHandler):
    server_instance = None # Class variable to store the server instance

    @classmethod
    def set_server_instance(cls, server):
        cls.server_instance = server # Set the server instance

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

                choice = easygui.buttonbox("Choose an option", "Server Control", ["Start", "Stop", "Exit"])
                if choice == "Start":
                    self.wfile.write(b"<script>alert('If you press this button, the server is already active. :)');</script>")
                elif choice == "Stop":
                    self.wfile.write(b"<script>alert('Server is stopping...');</script>")
                    self.server_instance.shutdown()
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
```

- At the following line of code behind `myServer = HTTPServer((hostName, hostPort), MyServer)`
```python
MyServer.set_server_instance(myServer)
```

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

> **NOTE:** If you're not working in a GUI environment, for example if you're using a SSH connection, you will probably get an error when connecting to the server. You can fix this problem to go simply to a GUI environment or you connect via SSH with a different command option.
```bash
ssh -X user@ip_address
```

> **NOTE:** This is a GUI interface, so you need to use a browser to see the interface.

![Image](/Images/W4P1-Python-1.png)

### 👉Exercise 8: Get the status of Apache

- Copy the contents of this file [complexserver3.py](/Scripts/complexserver3.py).

- Run the webserver with the following command
```bash
python3 basisserver3.py
```

![Image](/Images/W4P1-Python-2.png)

![Image](/Images/W4P1-Python-3.png)


## ⏱️Setup web server in one second

> **NOTE:** This will only work on a GUI environment.

```bash
# Download the necessary files
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/complexserver3.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Html/index.html
curl -O https://eliasdh.com/assets/media/images/logo.png

# Install the necessary software packages
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install python3-easygui python3-pip python3-venv lynx -y

# Move the files to the correct directories
sudo mv complexserver3.py /home/$(whoami)/complexserver3.py
sudo mv index.html /var/www/index.html
sudo mv logo.png /var/www/logo.png

# Create a virtual environment and install the necessary packages
python3 -m venv ~/my_venv
source ~/my_venv/bin/activate
pip3 install easygui psutil

# Run the webserver
python3 /home/$(whoami)/complexserver3.py
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com