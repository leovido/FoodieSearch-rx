//
//  ViewModelBlueprint.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 25/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import RxMoya

protocol ViewModelBlueprint {

    associatedtype AnyService: TargetType
    associatedtype Model: Decodable

    var disposeBag: DisposeBag { get }
    var provider: MoyaProvider<AnyService> { get }

    var dataSource: BehaviorRelay<[Model]> { get }
    var errorDataSourcePublisher: PublishSubject<Error> { get }

}
