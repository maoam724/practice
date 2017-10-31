//
//  RecipeViewController.swift
//  recipe
//
//  Created by mao takagai on 2017/10/15.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import UIKit
import RealmSwift

class RecipeViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var material: UILabel!
    
    var id:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(id ?? "nilです")
        
        let recipes = loadRecipes()
        
        let recipe = recipes.first(where: { (recipe) -> Bool in
            return self.hasSameId(recipe)
        })

        print("これ", recipe!)
        
    }
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }
    
    func hasSameId(_ recipe:  Recipe) -> Bool {
        return recipe.id == id
    }
    
    
    
    
    
}


