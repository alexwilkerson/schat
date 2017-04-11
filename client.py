from socket import socket, AF_INET, SOCK_STREAM

def client_prompt(sock):
    message = os.getlogin()
    while message != 'q':
        if message != '':
            sock.send(message.encode())
            data = sock.recv(1024)
            data = data.decode()
            print(data)
        message = input('-> ')
    sock.close()

def client_start():
    server = ('', 1338)

    sock = socket(AF_INET, SOCK_STREAM)
    sock.connect(server)
    client_prompt(sock)

if __name__ == '__main__':
    client_start()
