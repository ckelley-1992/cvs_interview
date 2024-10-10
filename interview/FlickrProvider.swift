//
//  FlickrProvider.swift
//  interview
//
//  Created by Connor Kelley on 10/9/24.
//

import Foundation

public struct FlickrProvider {
    static let shared = FlickrProvider()
    
    private init(){}
    
    public func fetchImages(from searchTerm: String, completionHandler: @escaping (NSDictionary)->()){
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchTerm)")!)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                debugPrint(error?.localizedDescription ?? "Unable to get response")
                completionHandler(NSDictionary())
                return
            }
            guard let responseData = try? JSONSerialization.jsonObject(with: data)
            else {
                debugPrint("Failed to convert response")
                completionHandler(NSDictionary())
                return
            }
            completionHandler(responseData as! NSDictionary)
        }.resume()
    }
}
