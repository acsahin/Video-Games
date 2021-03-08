//
//  APINetwork.swift
//  Video Games
//
//  Created by ACS on 5.03.2021.
//

import Foundation

class APINetwork {
    
    var delegate: APINetworkDelegate?
    var detailDelegate: APIDetailNetworkDelegate?
    
    var baseData = [VideoGame]()
    
    let headers = [
        "x-rapidapi-key": keyOfYours,
        "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
    ]
    
    func fetchData() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://rawg-video-games-database.p.rapidapi.com/games")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
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
    
    func fetchGameDetail(slug: String) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://rawg-video-games-database.p.rapidapi.com/games/\(slug)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let videoGame = try decoder.decode(VideoGame.self, from: safeData)
                        self.detailDelegate?.didGetDetail(self, videoGame: videoGame)
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

protocol APIDetailNetworkDelegate {
    func didGetDetail(_ apiNetwork: APINetwork, videoGame: VideoGame)
}
