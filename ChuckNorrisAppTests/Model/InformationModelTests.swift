//
//  InformationModelTests.swift
//  ChuckNorrisAppTests
//
//  Created by Глеб Николаев on 08.12.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import XCTest
@testable import ChuckNorrisApp

class InformationModelTests: XCTestCase {
    
    var joke: Joke!
    var sut: Information!

    override func setUp() {
        super.setUp()
        joke = Joke(joke: "Foo")
        sut = Information(value: [joke])
    }
    
    override func tearDown() {
        joke = nil
        sut = nil
        super.tearDown()
    }
    
    // Проверяем что объект типа Information не будет равен nil при инициализации с параметром value
    func testInformationInitializationWithValueParameter() {
        XCTAssertNotNil(sut)
    }
    
    // Проверяем мы можем установить установить значение для свойства value, при инициализации объекта типа Information
    func testWhenGivenValueSetsValue() {
        XCTAssertEqual(sut.value[0], joke)
    }
    
    // Проверяем равенство двух объектов типа Information
    func testAreInformationObjectsTheSame() {
        let joke = Joke(joke: "Foo")
        let information = Information(value: [joke])
        XCTAssertEqual(sut, information)
    }
    
}
