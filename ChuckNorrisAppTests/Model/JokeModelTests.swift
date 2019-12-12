//
//  ChuckNorrisAppTests.swift
//  ChuckNorrisAppTests
//
//  Created by Глеб Николаев on 07.12.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import XCTest
@testable import ChuckNorrisApp

class JokeModelTests: XCTestCase {
    
    var sut: Joke!

    override func setUp() {
        super.setUp()
        sut = Joke(joke: "Foo")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // Проверяем инициализируется ли наш объект с установкой свойства joke
    func testJokeInitializationWithJokeParameter() {
        XCTAssertNotNil(sut)
    }
    
    // Проверяем что в нашу шутку мы можем установить свойство joke при инициализации
    func testWhenGivenJokeSetsJoke() {
        XCTAssert(sut.joke == "Foo", "Joke Initialize With Another Parameter Value")
    }

}
