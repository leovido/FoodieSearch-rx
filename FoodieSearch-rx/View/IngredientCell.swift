//
//  IngredientCell.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 25/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit

class IngredientCell: UICollectionViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!

    static var identifier: String = "IngredientCell"

    func configure(element: String) {
        self.ingredientLabel.text = element
    }

}
