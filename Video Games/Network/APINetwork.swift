//
//  APINetwork.swift
//  Video Games
//
//  Created by ACS on 5.03.2021.
//

import Foundation

class APINetwork {
    
    var delegate: APINetworkDelegate?
    
    var baseData = [VideoGame]()
    
    let headers = [
        "x-rapidapi-key": "4d9031962fmshbd0f94c9fc9a412p17f8d5jsn3522866d1391",
        "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
    ]
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://rawg-video-games-database.p.rapidapi.com/games")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let videoGameList = try decoder.decode(VideoGameList.self, from: safeData)
                        self.baseData = videoGameList.results
                        self.delegate?.didUpdateVideoGames(self, videoGames: videoGameList.results)
                    } catch {
                        print("Error loading")
                    }
                    
                }
            }
        })
        dataTask.resume()
    }
}

protocol APINetworkDelegate {
    func didUpdateVideoGames(_ apiNetwork: APINetwork, videoGames: [VideoGame])
}
