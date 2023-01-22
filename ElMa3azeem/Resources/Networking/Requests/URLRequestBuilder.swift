import Foundation
import FirebaseMessaging
import Alamofire
 


protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: ServiceURL { get }
    
    var headers: HTTPHeaders { get }
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
    
    var fcmTokenDevice: String { get }
}

extension URLRequestBuilder {
    
    var mainURL: URL {
        return URL(string: URLs.BASE_API
        )!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path.rawValue)
    }
    
    var headers: HTTPHeaders {
        var header = HTTPHeaders()
        header["lang"] = Language.apiLanguage()
        return header
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }
    
    var fcmTokenDevice: String {
        print(Messaging.messaging().fcmToken ?? "token")
        return Messaging.messaging().fcmToken ?? "token"
    }
    
    func asURLRequest() throws -> URLRequest {
        
        print("\n\n====================================\n🚀🚀FULL REQUEST COMPONENETS::: \n URL:: \(String(describing: (urlRequest.url))) \n Method:: \(String(describing: urlRequest.httpMethod)) \n Header:: \(String(describing: urlRequest.allHTTPHeaderFields))  \n Parameters:: \(String(describing: parameters))\n====================================\n\n" )
        
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
