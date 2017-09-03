//
//  ViewController.swift
//  recipe
//
//  Created by mao takagai on 2017/07/03.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var recipiesTable: UITableView!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    var recipes: Results<Recipe>!
    var recipesForDate: Array<Recipe>!

    override func viewDidLoad() {
        super.viewDidLoad()
        recipiesTable.delegate = self
        recipiesTable.dataSource = self
        
        recipes = loadRecipes()
        recipesForDate = Array(recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: Date())
        })
        
        self.title = "201709"
        
        setUpCalendarview()
    }
    func setUpCalendarview() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    //realmから読み込む
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
        for recipe in recipes {
            print(recipe)
        }
        return recipes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//カレンダー関連
extension ViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        //表示させる日付の範囲
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let paramaters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return paramaters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCell
        cell.label.text = cellState.text
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        let recipesOnDate = recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: date)
        }
        
        if recipesOnDate.isEmpty {
            cell.label.textColor = .black
            return cell
        }
        print(date)
        cell.label.textColor = .red
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("押されたよ〜" + String(describing: date))
        recipesForDate = Array(recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: date)
        })
        recipiesTable.reloadData()
        
        guard let validCell = cell as? CalendarCell else {
            return
        }
        validCell.selectedView.isHidden = false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {
            return
        }
        validCell.selectedView.isHidden = true

    }
}

//選択された日付に紐付くレシピを表示する
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let recipe = recipesForDate[indexPath.row]
        cell.textLabel?.text = recipe.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesForDate.count
    }
    
}

