//
//  VPNAPIManager.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/28.
//

import Foundation
import Moya
enum APIManager {
    case xxxx
}

extension APIManager: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "xxxxx")!
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
            case .xxxx:
                return "xxx"
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method { return .get }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data {
        return Data()
        }

    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
            case .xxxx:
                return .requestPlain

        }
    }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .successCodes
    }

    /// The headers to be used in the request.
    var headers: [String: String]?  { nil }
}


private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

let apiManager = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                             logOptions: .verbose))])
