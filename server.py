from socket import socket, AF_INET, SOCK_STREAM

def chat_handler(address, client_sock):
    print("Connected to {}".format(address))
    try:
        user = client_sock.recv(1024)
        client_sock.send(user)
        while True:
            msg = client_sock.recv(1024)
            if not msg:
                break
            print(msg.decode())
            client_sock.send(msg)
    except socket.error:
        print("Error occurred.")
    print("Disconnected from {}.".format(address))
    client_sock.close()

def chat_server(address, backlog=5):
    print("Server started on address {}.".format(address[1]))
    sock = socket(AF_INET, SOCK_STREAM)
    sock.bind(address)
    sock.listen(backlog)
    while True:
        client_sock, client_addr = sock.accept()
        chat_handler(client_addr, client_sock)

if __name__ == '__main__':
    chat_server(('localhost', 1338))
