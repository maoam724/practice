//
//  RObject.swift
//  recipe
//
//  Created by mao takagai on 2017/10/21.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import Foundation
import RealmSwift

class RObject: Object {
    // ID
    dynamic var id = 0
    
    // データを保存。
    func save() {
        let realm = try! Realm()
        if realm.isInWriteTransaction {
            if self.id == 0 { self.id = self.createNewId() }
            realm.add(self, update: true)
        } else {
            try! realm.write {
                if self.id == 0 { self.id = self.createNewId() }
                realm.add(self, update: true)
            }
        }
    }
    
    // 新しいIDを採番します。
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
