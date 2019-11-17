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
    
    func fetchJokes(numberOfJokes: String, completion: @escaping (Information?) -> Void) {
           let url = "http://api.icndb.com/jokes/random/\(numberOfJokes)"
           
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

// MARK: Fetch Jokes from icndb.com (URL Session Realization)

/*
 
 func fetchJokes(numberOfJokes: String, completion: @escaping (Information?) -> Void) {
     
     guard var url = URL(string: "http://api.icndb.com/jokes/random/") else {
         print("Invalid URL")
         completion(nil)
         return
     }
     
     url.appendPathComponent(numberOfJokes)
     
     URLSession.shared.dataTask(with: url) { (data, response, error) in
         
         guard let data = data else {
             print("Unable to get data")
             completion(nil)
             return
         }
         
         guard let response = response as? HTTPURLResponse else {
             print("Can't recognize response")
             completion(nil)
             return
         }
         
         print("RESPONSE STATUS CODE: \(response.statusCode)")
         
         let jsonDecoder = JSONDecoder()
         
         guard let decodedInformation = try? jsonDecoder.decode(Information.self, from: data) else {
             print("Failed to decode JSON data")
             completion(nil)
             return
         }
         
         completion(decodedInformation)
         
     }.resume()
     
 }
 
 */
