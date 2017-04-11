import socket
import time, datetime
from datetime import datetime
import sqlite3
import atexit
from termcolors import *

host = ''
port = 1337

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind((host, port))

conn = sqlite3.connect('schat.db')
c = conn.cursor()

def send(line):
    try:
        f = open("/tmp/.schat.log", "a")
        f.write(line + default + "\n")
        f.close()
    except:
        print("error writing to log file.")
        f.close()

def thetime():
    return datetime.now().strftime("[%Y-%m-%d %H:%M]");

def windowlist(user):
    send(thetime() + white + " ~ " + green + "The car's current status as requested by (" + blue + user + green + "):")
    time.sleep(1)
    c.execute('SELECT user, windowstatus FROM windows')
    for row in c.fetchall():
        if int(row[1]) == 1:
            send(thetime() + magenta + " ~ " + green + row[0] + "'s window is up.")
        else:
            send(thetime() + blue + " ~ " + green + row[0] + "'s window is down.")
        time.sleep(1)

def window(user, status):
    c.execute('SELECT * FROM windows WHERE user=(?)', (user,))
    if len(c.fetchall()) > 0:
        c.execute('SELECT windowstatus FROM windows WHERE user=(?) AND windowstatus=(?)', (user, status))
        if len(c.fetchall()) == 0:
            c.execute('UPDATE windows SET windowstatus=(?) WHERE user=(?)', (status, user))
            if status == 1:
                send(thetime() + magenta + " ~ " + green + user + " put their window up.")
            else:
                send(thetime() + blue + " ~ " + green + user + " put their window down.")
        else:
            if status == 1:
                send(thetime() + red + " ~ " + user + " tries to put their window up, but it's already up.")
            else:
                send(thetime() + red + " ~ " + user + " tries to put their window down, but it's already down.")
    else:
        c.execute('INSERT INTO windows (user, windowstatus) VALUES (?, ?)', (user, status))
        if status == 1:
            send(thetime() + blue + " ~ " + green + user + " put their window up.")
        else:
            send(thetime() + magenta + " ~ " + green + user + " put their window down.")
    conn.commit()

def pleaserespond(userid, addr):
    sendto("rcvd".encode(), addr)

def motd(user, message):
    print("motd called")
    c.execute('INSERT INTO motd (date, user, message) VALUES (?, ?, ?)', (datetime.now(), user, message))
    conn.commit()
    send(bgwhite + black + thetime() + magenta + " % " + blue + user + black + " set the motd to: " + magenta + "\"" + message + "\"" + bgdefault)

def exit_function():
    s.close()
    c.close()
    conn.close()

def Main():
    atexit.register(exit_function)

    print("Schat Server Started...")

    while True:
        try:
            data, addr = s.recvfrom(1024)
            data = data.decode('utf-8').split()
            userid = data[0]
            command = data[1]
            print(data)
            if command == "killserver":
                print("Server killed by",userid,".")
                break;
            elif command == "window":
                window(userid, int(data[2]))
            elif command == "windowlist":
                windowlist(userid)
            elif command == "pleaserespond":
                pleaserespond(userid, addr)
            elif command == "motd":
                motd(userid, " ".join(data[2:]))
        except:
            pass

if __name__ == '__main__':
    Main()
