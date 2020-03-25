//
//  FoodieSearch_rxTests.swift
//  FoodieSearch-rxTests
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
import Moya
@testable import FoodieSearch_rx

class FoodieSearch_rxTests: XCTestCase {

    var sut: RecipeViewModel!

    override func setUp() {
        sut = RecipeViewModel(provider: makeMoyaSuccessStub())
    }

    override func tearDown() {
        sut = nil
    }

    func testRecipeViewModel() {
        sut.getRecipes(page: 1, ingredients: "", query: "")
    }

    private func makeMoyaSuccessStub<T: TargetType>() -> MoyaProvider<T> {

        let bundle = Bundle(for: type(of: self) as! AnyClass)

        let url = bundle.url(forResource: "recipes", withExtension: "json")!
        let data = try! Data(contentsOf: url)

        let serverEndpointSuccess = { (target: T) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                                            sampleResponseClosure: { .networkResponse(200, data) },
                                            method: target.method,
                                            task: target.task,
                                            httpHeaderFields: target.headers)
        }

        let serverStubSuccess = MoyaProvider<T>(
            endpointClosure: serverEndpointSuccess,
            stubClosure: MoyaProvider.immediatelyStub
        )

        return serverStubSuccess

    }

}
