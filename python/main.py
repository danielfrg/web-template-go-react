import time
from concurrent import futures

import grpc

from protos import helloworld_pb2
from protos import helloworld_pb2_grpc


_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class Greeter(helloworld_pb2_grpc.GreeterServicer):

    def SayHello(self, request, context):
        return helloworld_pb2.HelloReply(message='Hello, %s!' % request.name)


def serve():
    # private_key = open('../misc/localhost.key').read()
    # certificate_chain = open('../misc/localhost.crt').read()
    # credentials = grpc.ssl_server_credentials((
    #         (private_key, certificate_chain),))
    
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    helloworld_pb2_grpc.add_GreeterServicer_to_server(Greeter(), server)
    # server.add_secure_port('[::]:9001', credentials)
    server.add_insecure_port('[::]:9001')
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)

if __name__ == '__main__':
    serve()
