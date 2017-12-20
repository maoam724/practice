//
//  RecipeViewController.swift
//  recipe
//
//  Created by mao takagai on 2017/10/15.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class RecipeViewController: UIViewController {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var material: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func onTapButton(_ sender: Any) {
        delAlart()
    }
    
    let formatter = DateFormatter()
    
    var id:Int?
    
    var recipe:Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(id ?? "nilです")
        
        let recipes = loadRecipes()
        
        let recipeOptional = recipes.first(where: { (recipe) -> Bool in
            return self.hasSameId(recipe)
        })
        
        guard let recipe = recipeOptional else {
            print("レシピがないよ〜")
            return
        }
        
        date.text = dateFormatter(recipe.date)
        name.text = recipe.name
        comment.text = recipe.comment
        
        
        for value in recipe.materials {
            material.text = value.value
        }
        
        self.recipe = recipe
        
        guard let recipeImage = recipe.image else {
            self.image.image = UIImage(named: "defaultImage.png")
            return
        }
        
        guard let imageUrl = URL(string: recipeImage) else {
            return
        }
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [imageUrl], options: nil)
        
        //firstObjectの有無
        guard let aFirstObject = fetchResult.firstObject else {
            print("1",recipe.image ?? "URLはないよ〜１")
            
            presentAlert()
            return
        }
        
        let asset: PHAsset = aFirstObject
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 140, height: 140), contentMode: .aspectFill, options: nil) { (image, info) in
            // imageをセットする
            self.image.image = image
        }
       
      
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
    
    
    
    func presentAlert() {
        let alert = UIAlertController.init(
            title: "画像が見つからないよ〜",
            message: "画像が消されてるよ〜",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: {(action) -> Void in
                self.delUrl()
        }))
        present(alert, animated: true)
    }
    
    func delUrl() {
        
        let realm = try! Realm()
        try! realm.write {
            recipe.image = nil
            print(recipe.image ?? "画像URL削除されたよ〜")
        }
    }
    
    func delAlart() {
        
        let alert  = UIAlertController.init(
            title: "レシピの削除",
            message: "削除してよろしいですか？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "削除",
            style: .destructive,
            handler: { (UIAlertAction) in
                self.delRecipe()
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func delRecipe() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(recipe)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
}





