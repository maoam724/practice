//
//  RandomRecipe.swift
//  recipe
//
//  Created by mao takagai on 2017/11/06.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import Foundation
import RealmSwift

class RandomRecipe: ViewController {
    
        @IBOutlet weak var cancel: UIBarButtonItem!
    
    func loadRecipes2() -> Results<Recipe> {
        let realm = try! Realm()
        let recipe = realm.objects(Recipe.self)
        return recipe
    }
    
}
//    
//    func randRecipe(length: Int) -> String {
//        let recipe = loadRecipes2()
//        var recipes: String = ""
//        
//        for _ in 0...length {
//            let randomValue = arc4random_uniform(UInt32(recipe.count))
//            recipes += "\(recipe[recipe.advansedBy(Int32(randomValue))])"
//        }
//        return recipes
//    }
    
