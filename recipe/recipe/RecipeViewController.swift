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
        
        let recipe = recipes.filter { (recipe) -> Bool in
           print(recipe.id)
            return true
        }
        print("これ", recipe)
        
    }
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }
    
    
    
    
    
}


