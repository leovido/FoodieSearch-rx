//
//  RecipeCellTests.swift
//  FoodieSearch-rxTests
//
//  Created by Christian Leovido on 25/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import FoodieSearch_rx

class RecipeCellTests: XCTestCase {

    var sut: RecipeViewController!

    override func setUp() {

        sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController

        let navigationController = UINavigationController()

        UIApplication.shared.windows.first!.rootViewController = navigationController
        navigationController.pushViewController(sut, animated: false)

        sut.loadView()
    }

    override func tearDown() {
        sut = nil
    }

    func testConfigureCell() {

    }

}
