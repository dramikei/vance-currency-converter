//
//  Request.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 19/09/23.
//

import Foundation

public class Request: Identifiable {

    /// URL query parameters
    public var id = UUID().uuidString

    /// HTTP request method
    public enum Method: String {
        case get = "GET"
    }

    // MARK: - Public properties

    public let method: Method
    public let path: String
    public let query: [URLQueryItem]?
    public let isAuthenticated: Bool

    /// `HTTPURLResponse` received from the server, if any.
    public var response: HTTPURLResponse?

    public var urlComponents: URLComponents {
        guard let url = URL(string: path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            preconditionFailure("Invalid URL components.")
        }

        if let query = query {
            components.queryItems = query
        }

        return components
    }

    // MARK: - Init
    public init(method: Method, path: String, query: [URLQueryItem]?, isAuthenticated: Bool) {
        self.method = method
        var pathStr = path
        if pathStr.first == "/" {
            // Having '/' in the beginning replaces pathComponents in the baseURL
            // during `request.urlComponents.url(relativeTo: baseURL)`
            _ = pathStr.removeFirst()
        }
        self.path = pathStr
        self.query = query
        self.isAuthenticated = isAuthenticated
    }
}


// MARK: - Convenience methods

/// Extend Request to directly use `[URLQueryItems]` for `query` param
public extension Request {
    static func get(_ path: String, query: [URLQueryItem], isAuthenticated: Bool = true) -> Request {
        Request(method: .get, path: path, query: query, isAuthenticated: isAuthenticated)
    }
}

