


import Cocoa



typealias ErrorReason = (String)
typealias RequestResponse = (Any?, ErrorReason?)->()
extension URLRequest {
    var headerParam: [String: String]? {
        set {
            if let header = newValue {
                for (key, value) in header {
                    self.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        get {
            return self.allHTTPHeaderFields
        }
    }
}
class Request: NSObject {
    static let shared = Request()
    fileprivate override init() {}
    fileprivate func createRequest(urlString: String, requestType: RequestType) -> URLRequest? {
        if let url = URL(string: urlString) {
            var requestObj = URLRequest(url: url)
            requestObj.httpMethod = requestType.rawValue
            return requestObj
        }
        return nil
    }
    
    func dataTask(request: URLRequest, completion: @escaping (RequestResponse)) {
        URLSession.shared.dataTask(with: request, completionHandler: { (dataResult, response, error) in
            if let data = dataResult {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    completion(jsonObj, nil)
                }catch let error {
                    completion(nil, error.localizedDescription)
                }
            }else {
                completion(nil, error?.localizedDescription)
            }
        }).resume()
    }
    
    func makeGETRequest(urlString: String, headerParam: [String: String]?, completion: @escaping RequestResponse) {
        if var request = createRequest(urlString: urlString, requestType: .get) {
            request.headerParam = headerParam
            dataTask(request: request, completion: completion)
        }else {
            let error = "Invalid URL is invoked"
            completion(nil, error)
        }
    }
    func makePOSTRequest(urlString: String, headerParam: [String: String]?, body: [String: AnyObject]?, completion: @escaping RequestResponse) {
        if var request = createRequest(urlString: urlString, requestType: .post) {
            request.headerParam = headerParam
            if let httpBody = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            }
            dataTask(request: request, completion: completion)
        }else {
            let error = "Invalid URL is invoked"
            completion(nil, error)
        }
    }
}
