//
//  MusicVideoTests.swift
//  MusicVideoTests
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import XCTest

class MusicVideoTests: XCTestCase {

	let urlString = "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(10)/json"
	let api = APIManager()

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testLoadData() {
		let url = NSURL(string: urlString)
		let expectation = expectationWithDescription("GET \(url)")

		api.loadData(urlString) { (videos) in

			XCTAssertNotNil(videos, "Response failed! nil returned :(")

			XCTAssertTrue(videos.count > 0, "Response did not return any videos!!")

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(10) { (error) in
			if let requestError = error {
				print("error: \(requestError.description)")
			}
		}
	}

	func testRequest() {
		let url = NSURL(string: urlString)
		let expectation = expectationWithDescription("GET \(url)")

		api.requestData(urlString) { (data, response, error) in
			XCTAssertNil(error, "Respsone error!")
			XCTAssertNotNil(response, "Response is nil!")

			if let httpResonse = response as? NSHTTPURLResponse {
				XCTAssertEqual(httpResonse.statusCode, 200, "Response has status \(httpResonse.statusCode)")
			}
			else {
				XCTFail("Response is not of type NSHTTPURLResponse")
			}

			expectation.fulfill()
		}

		waitForExpectationsWithTimeout(10) { (error) in
			if let requestError = error {
				print("error: \(requestError.description)")
			}
		}
	}
}
