//
//  randomRacipes.swift
//  recipe
//
//  Created by mao takagai on 2017/11/06.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import Foundation
import RealmSwift

class RandomRecipeViewController: UIViewController {
    
    @IBAction func randomButton(_ sender: UIButton) {
        viewDidLoad()
    }

    
    @IBOutlet weak var todaysRecipeIs: UILabel!
    
    @IBOutlet weak var randomRecipe: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let recipes = loadRecipes()
        let index = Int(arc4random_uniform(UInt32(recipes.count)))
        
        print(recipes[index].name)
        randomRecipe.text = "＼　\(recipes[index].name)　／"
        
    }
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }

    
}
