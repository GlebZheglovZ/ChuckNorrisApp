//
//  NetworkManger.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private let baseURL = "http://api.icndb.com/jokes/random/"
    
    // MARK: - Fetch Jokes from icndb.com (Alamofire Realization)
    
    func fetchJokes(numberOfJokes: String, completion: @escaping (Information?) -> Void) {
        guard var url = URL(string: baseURL) else { return }
        url = url.appendingPathComponent(numberOfJokes)
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else {
                print("Unable to get data")
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            guard let decodedInformation = try? jsonDecoder.decode(Information.self, from: data) else {
                print("Failed to decode JSON data")
                completion(nil)
                return
            }
            
            completion(decodedInformation)
        }
    }
    
}
