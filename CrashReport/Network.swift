//
//  Network.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation

struct Result {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

struct LPData {
    let code: Int
    let message: String
    let data: Dictionary<String, Any>
}

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}

typealias SuccessHandler = (Result) -> Void
typealias FailedHandler = (Result) -> Void

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]


class Network {
    
    static let shared = Network()
    var headers = HTTPHeaders()
    var session = URLSession.shared
    
    private init() {
        
    }
    
    func request(method: Method, urlStr: String, parameter: Parameters? = nil, success: @escaping SuccessHandler, fail: @escaping FailedHandler) {
        
        guard let request = encode(method: method, urlStr, parameters: parameter) else { return }
        session.dataTask(with: request) { (data, response, error) in
            let result = Result(data: data, response: response, error: error)
            if let _ = error {
                fail(result)
            }else{
                success(result)
            }
        }.resume()
    }
    
    private func encode(method: Method, _ urlStr: String, parameters: Parameters? = nil) -> URLRequest? {
        
        guard let url = URL(string: urlStr) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        switch method {
        case .GET:
            var urlString = urlStr
            if let parameters = parameters {
                urlString = urlString + "?" + query(parameters)
                urlRequest.url = URL(string: urlString)
            }
        case .POST:
            if let parameters = parameters {
                urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
            }
        }
        return urlRequest
    }
    
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}







