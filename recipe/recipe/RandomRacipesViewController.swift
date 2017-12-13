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
       setRandomRecipe()
    }

    
    @IBOutlet weak var todaysRecipeIs: UILabel!
    
    @IBOutlet weak var randomRecipe: UILabel!
    
    @IBAction func details(_ sender: Any) {
        performSegue(withIdentifier: "RecipeViewController", sender: sender)
    }
    
    var recipeId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRandomRecipe()
    }
    
    func setRandomRecipe() {
        let recipes = loadRecipes()
        let index = Int(arc4random_uniform(UInt32(recipes.count)))
        
        print(recipes[index].name)
        recipeId = recipes[index].id
        randomRecipe.text = "＼　\(recipes[index].name)　／"
    }
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier ?? "ないよ〜")
        
        if segue.identifier == "RecipeViewController" {
            let recipeViewController = segue.destination as! RecipeViewController
        
            print(recipeId)
            recipeViewController.id = recipeId
        }
    }

}
