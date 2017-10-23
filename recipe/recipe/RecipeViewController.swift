//
//  RecipeViewController.swift
//  recipe
//
//  Created by mao takagai on 2017/10/15.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var material: UILabel!
    
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(recipe ?? "nilだよ〜")
    }
    
}
