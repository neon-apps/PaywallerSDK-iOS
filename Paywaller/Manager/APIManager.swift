//
//  APIManager.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation


class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://paywaller.io"

    func getPaywall(id: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        sendRequest(endpoint: "/api/getPaywall", id: id, method: "GET", completion: completion)
    }

    
    private func sendRequest(endpoint: String, id: String? = nil, appID: String? = nil, jsonData: [String: Any]? = nil, method: String = "POST", completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var urlString = baseURL + endpoint
        

        
        urlString += "?api_key=\(Constants.apiKey)"
        
        if let id = id {
            urlString += "&id=\(id)"
        }
        if let appID = appID {
            urlString += "&appID=\(appID)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        
        if let jsonData = jsonData {
            request.httpMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if method == "POST" {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonData)
                    request.httpBody = jsonData
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let json = json {
                    if let status = json["status"] as? String{
                        if status == "error"{
                            completion(.failure(NSError(domain: "Got error", code: 0, userInfo: nil)))
                        }else{
                            completion(.success(json))
                        }
                    }else{
                        completion(.failure(NSError(domain: "Can't found status", code: 0, userInfo: nil)))
                    }
                  
                    print(json)
                } else {
                    completion(.failure(NSError(domain: "Invalid response format", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
