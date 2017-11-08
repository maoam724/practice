//
//  Menu.swift
//  recipe
//
//  Created by mao takagai on 2017/11/06.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import Foundation
import RealmSwift

class MenuViewController: UIViewController  {
    
    var sideMenuView: UITableView!
    var sideBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    func createView() {
        var barHeight: CGFloat!
        var displayWidth: CGFloat!
        var displayHeight: CGFloat!
        barHeight = UIApplication.shared.statusBarFrame.size.height // 表示されるステータスバーの高さを取得
        displayWidth = UIScreen.main.bounds.size.width // 表示する画面の幅を取得
        displayHeight = UIScreen.main.bounds.size.height // 表示する画面の高さを取得
        
        self.view.frame = CGRect(x:0, y:0, width:displayWidth, height:displayHeight) // 元々のViewのサイズを指定
        
        // メニューのViewを作成
        sideMenuView = UITableView(frame: CGRect(x:0, y:barHeight, width:displayWidth * 0.7, height:displayHeight - barHeight)) // CGRect(x: x座標, y: y座標, with: 横幅, height:高さ)を指定
        sideMenuView.backgroundColor = UIColor.black // 背景に黒を指定
        sideMenuView.alpha = 0.9 // 透明度を指定
        
//        // 下記でメニューをタップしたときのためにセルのIDの指定やdelegateの指定を行っている
//        sideMenuView.register(UITableViewCell.self, forCellReuseIdentifier: "SideCell")
//        sideMenuView.dataSource = self
//        sideMenuView.delegate = self
//        sideMenuView.tableFooterView = UIView()
//        
        view.addSubview(sideMenuView) // 作成したViewをメインのViewに追加し、表示されるようにする
        
        // 背景viewを作成
        sideBackView = UIView(frame: CGRect(x:displayWidth * 0.7, y:barHeight, width:displayWidth * 0.3, height:displayHeight - barHeight))
        sideBackView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.addSubview(sideBackView)
    }
    

}
