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
    var selectedRecipe: Recipe!
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState, hasRecipes: Bool) {
        guard let validCell = view as? CalendarCell else {
            print("invalidcell")
        return
        }
        print(cellState.dateBelongsTo)
        if cellState.isSelected {
            if hasRecipes {
                validCell.label.textColor = .red
            } else {
                validCell.label.textColor = .white
            }
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                if hasRecipes {
                    validCell.label.textColor = .red
                } else {
                    validCell.label.textColor = .black
                }
            } else {
                validCell.label.textColor = .gray
            }
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {
        return
        }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recipiesTable.delegate = self
        recipiesTable.dataSource = self
        
        recipes = loadRecipes()
        let today = Date()
        recipesForDate = Array(recipes.filter { (recipe:Recipe) -> Bool in
            return Calendar.current.isDate(recipe.date, inSameDayAs: today)
        })
        
        
        setUpCalendarview()
    }
    func setUpCalendarview() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (dates) in
            let date = dates.monthDates.first?.date
            self.title = self.dateToTitle(date!)
        }
    }
    
    //realmから読み込む
    func loadRecipes() -> Results<Recipe> {
        let realm = try! Realm()
        let recipes = realm.objects(Recipe.self)
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
        let startDate = formatter.date(from: "2017 10 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let paramaters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return paramaters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCell
        cell.label.text = cellState.text
       
        handleCellSelected(view: cell, cellState: cellState)
        
        let recipesOnDate = recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: date)
        }
        
        handleCellTextColor(view: cell, cellState: cellState, hasRecipes: !recipesOnDate.isEmpty)
        
        
        

//        if recipesOnDate.isEmpty {
//            cell.label.textColor = .black
//            return cell
//        }
//        print(date)
//        cell.label.textColor = .white
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("押されたよ〜" + String(describing: date))
        recipesForDate = Array(recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: date)
        })
        recipiesTable.reloadData()
        handleCellSelected(view: cell, cellState: cellState)
        
        handleCellTextColor(view: cell, cellState: cellState, hasRecipes: !recipesForDate.isEmpty)
    
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        let recipesOnDate = recipes.filter { (recipe) -> Bool in
            Calendar.current.isDate(recipe.date, inSameDayAs: date)
        }
        handleCellTextColor(view: cell, cellState: cellState, hasRecipes: !recipesOnDate.isEmpty)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        title = dateToTitle(date)
    }
    
    func dateToTitle(_ date: Date) -> String {
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        
        return year + month
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipesForDate[indexPath.row]
        performSegue(withIdentifier: "RecipeViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier ?? "ないよ〜")
        
        if segue.identifier == "RecipeViewController" {
            let recipeViewController = segue.destination as! RecipeViewController
            print(selectedRecipe)
            recipeViewController.id = selectedRecipe.id
        }
    }
    
}


