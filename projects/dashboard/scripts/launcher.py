from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):

        apps = {
            "calcurse": [
                "foot",
                "-e",
                "calcurse"
            ],

            "termcal": [
                "foot",
                "-e",
                "termcal"
            ],
"gittree": [
    "foot",
    "-e",
    "sh",
    "-c",
    "cd ~/dotfiles && git tree; echo; read -r _"
],


            "foot": [
                "foot"
            ]
        }

        app = self.path[1:]

        if app in apps:
            subprocess.Popen(apps[app])

        self.send_response(200)
        self.end_headers()


HTTPServer(("127.0.0.1", 9999), Handler).serve_forever()
