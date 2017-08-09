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
    
    let formatter = DateFormatter()
    var recipes: Results<Recipe>!
    var recipesForDate: List<Recipe>!

    override func viewDidLoad() {
        super.viewDidLoad()
        recipes = loadRecipes()
//        recipesForDate = recipes.filter { (recipe:Recipe) -> Bool in
//            Calendar.current.isDate(recipe.date, inSameDayAs: Date())
//        }
    }
    
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

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let paramaters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return paramaters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCell
        cell.label.text = cellState.text
        
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
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tableCell")!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: Date())
        }
        .count
    }
    
}

