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

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var material: UILabel!
    
    let formatter = DateFormatter()
    
    var id:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(id ?? "nilです")
        
        let recipes = loadRecipes()
        
        let recipe = recipes.first(where: { (recipe) -> Bool in
            return self.hasSameId(recipe)
        })

        print("これ", recipe!)
        
        date.text = dateFormatter((recipe?.date)!)
        name.text = recipe?.name
        comment.text = recipe?.comment
        
        for value in (recipe?.materials)! {
            material.text = value.value
        }
        
//        print("材料",recipe?.materials ?? "nilでーす")

//        var theMaterial = (recipe?.materials)!
//        print(String(describing: type(of: theMaterial)))
        
    }
  
    
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        return recipes
    }
    
    func hasSameId(_ recipe:  Recipe) -> Bool {
        return recipe.id == id
    }
    
    func dateFormatter(_ date: Date) -> String {
        formatter.dateFormat = "yyyy年 MM月 dd日"
        let ymd = formatter.string(from: date)
        return ymd
    }
    
    
}




