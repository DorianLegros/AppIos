//
//  ShowServices.swift
//  AppIos
//
//  Created by user214997 on 3/15/22.
//

import Foundation

let apiKey = "aad3716237ce5a86c2a02e2a48f662c1";
let baseUrl = "https://api.themoviedb.org/3/tv/";

class ShowServices {
    func fetchAiringTodayShows() {
        let url = URL(string: baseUrl + "airing_today?api_key=" + apiKey + "&language=fr-FR")!;
        debugPrint(baseUrl + "airing_today?api_key=" + apiKey + "&language=fr-FR");
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print("running")
                // est-ce qu'une erreur a lieu?
                  if let error = error {
                    debugPrint("Error with fetching shows: \(error)")
                    return
                  } else {
                    debugPrint("No error")
                  }
                // pas d'erreur
                // affection if  != nil else
                // récupère la réponse http 2xx
                  guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                  else {
                    // \{id}
                    debugPrint("Error with the response, unexpected status code: \(response)")
                    debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                    return
                  }
                // analyse des données
                  if let data = data{
                    debugPrint("data")
                    print(String(bytes: data, encoding: .utf8) )
                    let show = try! JSONDecoder().decode(Show.self, from: data)
                    DispatchQueue.main.async() {
                        print(show)
                    }
                  }else{
                    print("no data")
                    return
                  }
                }).resume()
    }
}


