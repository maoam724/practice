//
//  Recipe.swift
//  recipe
//
//  Created by mao takagai on 2017/08/06.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import Foundation
import RealmSwift

class Recipe: Object {
    dynamic var date = Date()
    dynamic var name: String = ""
    dynamic var comment: String?
    let materials = List<RealmString>()
}
