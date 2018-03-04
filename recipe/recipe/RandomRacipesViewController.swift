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
    
    
    
    @IBOutlet weak var detailsButton: UIButton!
    

    @IBOutlet weak var todaysRecipeIs: UILabel!
    @IBOutlet weak var randomRecipe: UILabel!
    
    var recipeId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomRecipe.text = "何にしよう ？"
        
        detailsButton.addTarget(self, action: #selector(details), for: .touchUpInside)
        detailsButton.isHidden = true
    }
    
    func setRandomRecipe() {
        let recipes = loadRecipes()
        let index = Int(arc4random_uniform(UInt32(recipes.count)))
        
        print(recipes[index].name)
        recipeId = recipes[index].id
        randomRecipe.text = "＼ \(recipes[index].name) ／"
        detailsButton.isHidden = false
        
    }
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }
    

    
    func details(sender: UIButton) {
        print("secondButton押されたよ〜")
        performSegue(withIdentifier: "ToDetail", sender: UIButton())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDetail" {
            let recipeViewController = segue.destination as! RecipeViewController
        
            print(recipeId)
            recipeViewController.id = recipeId
            
        }
    }

}
