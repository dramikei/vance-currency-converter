//
//  APIClient.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 19/09/23.
//

import Foundation

public enum APIError: Int, Error {
    case notFound404 = 404
    case apiKeyMissing = 101
    case endpointDoesNotExist = 103
    case apiQuotaExhausted = 104
    case subscriptionDoesNotSupportThisAPI = 105
    case currentRequestDoesNotReturnData = 106
    case accountInactive = 102
    case invalidBaseCurrency = 201
    case invalidSymbols = 202
    case noDateSpecified = 301
    case inValidDateSpecified = 302
    case noOrInvalidDateSpecified = 403
    case noOrInvalidTimeFrameSpecified = 501
    case noOrInvalidStartDateSpecified = 502
    case noOrInvalidEndDateSpecified = 503
    case invalidTimeFrameSpecified = 504
    case timeFrameTooLong = 505
    case decodingFailure
    case unknown
    case unhandledStatusCode
}

public class APIClient {

    public static var shared = APIClient()

    // MARK: - Private properties

    private let baseURL: URL
    private let session: URLSession
    private let apiKey: String!

    public init() {
        // Not using Cookies for auth or anything else.
        // Useful if same API serves Frontend + iOS, and for some reason uses cookies for frontend and JWT for iOS
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpCookieAcceptPolicy = .never
        sessionConfiguration.httpShouldSetCookies = false
        self.session = URLSession(configuration: sessionConfiguration)

        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { fatalError("Info Dict is missing!") }

        // Set base URL from XCConfig
        if let baseURL = infoDictionary["BASE_URL"] as? String {
            self.baseURL = URL(string: baseURL)!
        } else {
            fatalError("BASE URL is missing!")
        }

        // Set API key from XCConfig
        if let apiKey = infoDictionary["API_KEY"] as? String {
            self.apiKey = apiKey
        } else {
            fatalError("API Key is missing!")
        }
    }


    public func send<T: Codable>(_ request: Request) async -> Result<T, APIError> {
        do {
            let urlRequest = makeURLRequest(for: request)
            let (data, urlResponse) = try await session.data(for: urlRequest)

            // Decode data into specified response type.

            let decoded: T = try JSONDecoder().decode(T.self, from: data)

            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(.decodingFailure)
            }

            switch urlResponse.statusCode {
            case 200..<300:
                return .success(decoded)
            default:
                if let err = APIError(rawValue: urlResponse.statusCode) {
                    return .failure(err)
                }
                return .failure(.unhandledStatusCode)
            }


        } catch {
            print("ERROR LOADING API: \(error)")
            return .failure(.unknown)
        }
    }

    func makeURLRequest(for request: Request) -> URLRequest {
        // NOTE: - Do not include "/" at the start of request.path as that replaces the pathComponent in the baseURL
        guard var url = request.urlComponents.url(relativeTo: baseURL) else {
            preconditionFailure("Unable to construct URL with the given baseURL")
        }

        if request.isAuthenticated {
            // Append API Key
            url.append(queryItems: [.init(name: "access_key", value: self.apiKey)])
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        // We can also append Request ID here in case we want to send it to Backend for bug backtracking.

        return urlRequest
    }

}
