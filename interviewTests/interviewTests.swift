//
//  interviewTests.swift
//  interviewTests
//
//  Created by Connor Kelley on 10/10/24.
//

import XCTest
import Foundation
import interview

final class interviewTests: XCTestCase {

    func testServerAndResponseFormat() async throws {
        let session = URLSession.shared
        let apiURL = URL(string:"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine")!
        let dataAndResponse: (data: Data, response: URLResponse) = try await session.data(from: apiURL, delegate: nil)
        
        let httpResponse = try? XCTUnwrap(dataAndResponse.response as? HTTPURLResponse, "Unexpected response type")
        XCTAssertEqual(200, httpResponse!.statusCode, "Expected 200 OK response")
        
        guard let responseData = try? JSONSerialization.jsonObject(with: dataAndResponse.data) as? NSDictionary
        else {
            XCTAssert(false, "Response was invalid")
            return
        }
        
        let results = responseData["items"]
        for result in results as! [NSDictionary]
        {
            print(result)
            let imageRef = result["media"] as! NSDictionary
            XCTAssert(!imageRef["m"].debugDescription.isEmpty)
            XCTAssert(!result["title"].debugDescription.isEmpty)
            XCTAssert(!result["description"].debugDescription.isEmpty)
            XCTAssert(!result["author"].debugDescription.isEmpty)
            XCTAssert(!result["date"].debugDescription.isEmpty)
        }
    }
}
