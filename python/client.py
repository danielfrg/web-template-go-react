from __future__ import print_function

import grpc

from _proto import helloworld_pb2
from _proto import helloworld_pb2_grpc


def run():
    # creds = grpc.ssl_channel_credentials(open('../misc/localhost.crt').read())
    # channel = grpc.secure_channel('localhost:9001', creds)
    channel = grpc.insecure_channel('localhost:9001')
    stub = helloworld_pb2_grpc.GreeterStub(channel)
    response = stub.SayHello(helloworld_pb2.HelloRequest(name='you'))
    print("Greeter client received: " + response.message)


if __name__ == '__main__':
  run()
