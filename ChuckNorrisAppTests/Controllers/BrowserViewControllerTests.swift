//
//  BrowserViewControllerTests.swift
//  ChuckNorrisAppTests
//
//  Created by Глеб Николаев on 12.12.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import XCTest
@testable import ChuckNorrisApp

class BrowserViewControllerTests: XCTestCase {
    
    var sut: BrowserViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: BrowserViewController.self)) as? BrowserViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testWhileBrowserViewControllerIsLoadedWebViewNotNil() {
        XCTAssertNotNil(sut.webView)
    }
    
    func testWebViewDelegateIsBrowserViewController() {
        XCTAssertTrue(sut.webView.delegate is BrowserViewController)
    }
    
    func testWebViewIsScaledToFitForContentView() {
        XCTAssertTrue(sut.webView.scalesPageToFit)
    }
    
    func testWhileBrowserViewControllerIsLoadedActivityIndicatorNotNil() {
        XCTAssertNotNil(sut.activityIndicator)
    }
    
    func testActivityIndicatorIsHiddenWhenViewIsLoaded() {
        XCTAssertTrue(!sut.activityIndicator.isHidden)
    }
    
    func testActivityIndicatorHidesWhenStopped() {
        XCTAssertTrue(sut.activityIndicator.hidesWhenStopped)
    }
    
    func testWebViewWhenURLLoadingIsFinished() {
        sut.webViewDidFinishLoad(sut.webView)
        XCTAssertTrue(!sut.webView.isHidden)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }
    
}
