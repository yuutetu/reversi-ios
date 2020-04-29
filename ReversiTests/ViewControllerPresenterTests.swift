//
//  ViewControllerPresenterTests.swift
//  ReversiTests
//
//  Created by 加賀江 優幸 on 2020/04/29.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import XCTest
@testable import Reversi

class ViewControllerPresenterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ValueChangedによりdarkの値が更新される() {
        let presenter = ViewControllerPresenter()
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .manual)
        presenter.playerControlValueChangedEvent.send(.dark)
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .computer)
        presenter.playerControlValueChangedEvent.send(.dark)
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .manual)
    }

    func test_ValueChangedによりlightの値が更新される() {
        let presenter = ViewControllerPresenter()
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .manual)
        presenter.playerControlValueChangedEvent.send(.light)
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .computer)
        presenter.playerControlValueChangedEvent.send(.light)
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .manual)
    }

    func test_ChangeRequestによりdarkの値が更新される() {
        let presenter = ViewControllerPresenter()
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .manual)
        presenter.playerControlChangeRequest.send((.dark, .computer))
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .computer)
        presenter.playerControlChangeRequest.send((.dark, .manual))
        XCTAssertEqual(presenter.darkPlayerControlSubject.value, .manual)
    }

    func test_ChangeRequestによりlightの値が更新される() {
        let presenter = ViewControllerPresenter()
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .manual)
        presenter.playerControlChangeRequest.send((.light, .computer))
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .computer)
        presenter.playerControlChangeRequest.send((.light, .manual))
        XCTAssertEqual(presenter.lightPlayerControlSubject.value, .manual)
    }

}

