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
    @IBOutlet weak var recipesTableView: UITableView!

    let disposeBag = DisposeBag()
    let viewModel: RecipeViewModel = RecipeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.parent?.title = "Recipes"

        setupSearchBar()
        setupBindings()
        setupErrors()
    }

    func setupErrors() {

        viewModel.errorRecipesPublisher
            .asObserver()
            .subscribe(onNext: { error in
                
                self.showAlertError(error)
            })
        .disposed(by: disposeBag)

    }

    func setupSearchBar() {

        recipeSearchBar.rx.text
            .orEmpty
            .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { query in
                self.viewModel.getRecipes(page: 1, ingredients: "", query: query)
            }, onError: { error in
                print(error)
            })
        .disposed(by: disposeBag)

    }

    func setupBindings() {

        viewModel.recipes
        .asObservable()
            .bind(to: recipesTableView.rx.items(cellIdentifier: RecipeCell.identifier,
                                                cellType: RecipeCell.self)) { _, element, cell in

                cell.configureCell(recipe: element)

            }
        .disposed(by: disposeBag)

    }

    func showAlertError(_ error: Error) {

        let alert = UIAlertController(title: "Something happened..", message: error.localizedDescription, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)

    }

}

