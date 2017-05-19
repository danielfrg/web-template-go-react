import {grpc, BrowserHeaders} from "grpc-web-client";
import {Greeter} from "./protos/helloworld_pb_service";
import {HelloRequest, HelloReply} from "./protos/helloworld_pb";

// const host = "https://localhost:8443";
const host = "http://localhost:8080";

export function externalGRPC() {
  console.log("Querying external python with WebGRPC Proxy");
  const helloRequest = new HelloRequest();
  helloRequest.setName("daniel");
  grpc.invoke(Greeter.SayHello, {
    request: helloRequest,
    host: host,
    onHeaders: (headers: BrowserHeaders) => {
      console.log("externalGRPC.onHeaders", headers);
    },
    onMessage: (message: HelloReply) => {
      console.log("externalGRPC.onMessage", message.toObject());
    },
    onEnd: (code: grpc.Code, msg: string, trailers: BrowserHeaders) => {
      console.log("externalGRPC.onEnd", code, msg, trailers);
    }
  });
}
