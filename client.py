import socket
import threading
import time

def Main():
    host = ''
    port = 0

    server = ('', 1337)

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind((host, port))
    s.setblocking(0)

    message = input("-> ")
    while message != 'q':
        if message != '':
            s.sendto(message.encode(), server)
        message = input("-> ")

    s.close()

if __name__ == '__main__':
    Main()
