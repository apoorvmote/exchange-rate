//
//  Networking.swift
//  exchange rate
//
//  Created by Apoorv Mote on 21/03/19.
//  Copyright © 2019 Apoorv Mote. All rights reserved.
//

import Foundation

struct rates: Decodable {
    
    var date: String
    
    var base: String
    
    var rates: [String: Double]
}

enum Result {
    
    case failure
    
    case success(rates)
}

let urlString = "https://api.exchangeratesapi.io/latest"

//func getLatest(completion: @escaping (Result) -> Void) {
//
//    guard let url = URL(string: urlString) else { completion(.failure); return  }
//
//    URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//        guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200, let data = data else { completion(.failure); return }
//
//        do {
//
//            let exchangeRates = try JSONDecoder().decode(rates.self, from: data)
//
//            completion(.success(exchangeRates))
//        }
//        catch { completion(.failure) }
//
//        }.resume()
//}

func getRatesFor(base: String?, currencies: [String]?, completion: @escaping (Result) -> Void) {
    
    let base = base ?? "EUR"
    
    var components = URLComponents(string: urlString)
    
    let baseQuery = URLQueryItem(name: "base", value: base)
    
    if let currencies = currencies {
        
        let symbolQuery = URLQueryItem(name: "symbols", value: currencies.joined(separator: ","))
        
        components?.queryItems = [baseQuery, symbolQuery]
    }
    else {
        
        components?.queryItems = [baseQuery]
    }
    
    guard let absoluteString = components?.string, let url = URL(string: absoluteString) else { completion(.failure); return  }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200, let data = data else { completion(.failure); return }
        
        do {
            
            let exchangeRates = try JSONDecoder().decode(rates.self, from: data)
            
            completion(.success(exchangeRates))
        }
        catch { completion(.failure) }
        
        }.resume()
}
