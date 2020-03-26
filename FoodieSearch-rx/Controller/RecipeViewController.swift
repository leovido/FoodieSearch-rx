//
//  ViewController.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!

    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var ingredientCollectionView: UICollectionView!

    var query: String = ""
    var ingredientsQuery: BehaviorRelay<String> = BehaviorRelay(value: "")

    let disposeBag = DisposeBag()
    let viewModel: RecipeViewModel = RecipeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.parent?.title = "Recipes"

        setupSearchBar()
        setupIngredientSearchBar()
        setupBindings()
        setupBindingCollectionView()
        setupErrors()
    }

    func setupErrors() {

        viewModel.errorDataSourcePublisher
            .asObserver()
            .subscribe(onNext: { error in
                
                self.showAlertError(error)
            })
        .disposed(by: disposeBag)

    }

    func setupSearchBar() {

        recipeSearchBar.rx.text
            .orEmpty
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { query in

                self.query = query

                self.viewModel.getRecipes(page: 1, ingredients: self.ingredientsQuery.value, query: query)

            }, onError: { error in
                self.showAlertError(error)
            })
        .disposed(by: disposeBag)

    }

    func setupIngredientSearchBar() {

        ingredientSearchBar.rx.text
            .orEmpty
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { query in
                self.viewModel.getRecipes(page: 1, ingredients: self.ingredientsQuery.value, query: self.query)
            }, onError: { error in
                self.showAlertError(error)

            })
        .disposed(by: disposeBag)

    }

    func setupBindings() {

        viewModel.dataSource
        .asDriver(onErrorJustReturn: [])
            .drive(recipesTableView.rx.items(cellIdentifier: RecipeCell.identifier,
                                                cellType: RecipeCell.self)) { _, element, cell in

                cell.configureCell(recipe: element)

            }
        .disposed(by: disposeBag)

        ingredientsQuery
            .bind(to: ingredientSearchBar.rx.text)
        .disposed(by: disposeBag)

    }

    func setupBindingCollectionView() {

        Observable.just(["Kale", "Tuna", "Eggs", "Bread", "Salmon"])
            .asObservable()
            .debug("ingredients", trimOutput: true)
            .bind(to: ingredientCollectionView.rx.items(cellIdentifier: IngredientCell.identifier, cellType: IngredientCell.self)) { _, element, cell in

                cell.configure(element: element)
        }
        .disposed(by: disposeBag)

        ingredientCollectionView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { ingredient in

                let previous = self.ingredientsQuery.value
                self.ingredientsQuery.accept(previous)

                if previous.isEmpty {
                    self.ingredientsQuery.accept(previous + ingredient)
                } else {
                    self.ingredientsQuery.accept(previous + ", " + ingredient)
                }


            }, onError: { error in
                self.showAlertError(error)
            })
        .disposed(by: disposeBag)

    }

    func showAlertError(_ error: Error) {

        let alert = UIAlertController(title: "Something happened..", message: error.localizedDescription, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)

    }

}

