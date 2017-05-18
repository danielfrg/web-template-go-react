// package: library
// file: book_service.proto

import * as book_service_pb from "./book_service_pb";
export class BookService {
  static serviceName = "library.BookService";
}
export namespace BookService {
  export class GetBook {
    static readonly methodName = "GetBook";
    static readonly service = BookService;
    static readonly requestStream = false;
    static readonly responseStream = false;
    static readonly requestType = book_service_pb.GetBookRequest;
    static readonly responseType = book_service_pb.Book;
  }
  export class QueryBooks {
    static readonly methodName = "QueryBooks";
    static readonly service = BookService;
    static readonly requestStream = false;
    static readonly responseStream = true;
    static readonly requestType = book_service_pb.QueryBooksRequest;
    static readonly responseType = book_service_pb.Book;
  }
}
