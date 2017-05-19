// package: helloworld
// file: helloworld.proto

import * as helloworld_pb from "./helloworld_pb";
export class Greeter {
  static serviceName = "helloworld.Greeter";
}
export namespace Greeter {
  export class SayHello {
    static readonly methodName = "SayHello";
    static readonly service = Greeter;
    static readonly requestStream = false;
    static readonly responseStream = false;
    static readonly requestType = helloworld_pb.HelloRequest;
    static readonly responseType = helloworld_pb.HelloReply;
  }
}
