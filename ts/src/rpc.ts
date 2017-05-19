import {grpc, BrowserHeaders} from "grpc-web-client";
import {BookService} from "./protos/book_service_pb_service";
import {QueryBooksRequest, Book, GetBookRequest} from "./protos/book_service_pb";

const host = "http://localhost:9000";

export function getBook() {
  console.log("Querying WebGRPC.getBook");
  const getBookRequest = new GetBookRequest();
  getBookRequest.setIsbn(60929871);
  grpc.invoke(BookService.GetBook, {
    request: getBookRequest,
    host: host,
    onHeaders: (headers: BrowserHeaders) => {
      console.log("getBook.onHeaders", headers);
    },
    onMessage: (message: Book) => {
      console.log("getBook.onMessage", message.toObject());
    },
    onEnd: (code: grpc.Code, msg: string, trailers: BrowserHeaders) => {
      console.log("getBook.onEnd", code, msg, trailers);
    }
  });
}

export function queryBooks() {
  console.log("Querying WebGRPC.queryBooks");
  const queryBooksRequest = new QueryBooksRequest();
  queryBooksRequest.setAuthorPrefix("Geor");
  grpc.invoke(BookService.QueryBooks, {
    request: queryBooksRequest,
    host: host,
    onHeaders: (headers: BrowserHeaders) => {
      console.log("queryBooks.onHeaders", headers);
    },
    onMessage: (message: Book) => {
      console.log("queryBooks.onMessage", message.toObject());
    },
    onEnd: (code: grpc.Code, msg: string, trailers: BrowserHeaders) => {
      console.log("queryBooks.onEnd", code, msg, trailers);
    }
  });
}
