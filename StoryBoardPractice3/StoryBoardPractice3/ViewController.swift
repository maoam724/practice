//
//  ViewController.swift
//  StoryBoardPractice3
//
//  Created by mao takagai on 2017/05/07.
//  Copyright © 2017年 mao takagai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {
        

    
    @IBOutlet weak var myTextField: UITextField!

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //myTextFieldのデリゲートになる
        myTextField.delegate = self
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //変更後の内容を作成する
        let tmpStr = textField.text! as NSString
        let replacedString = tmpStr.replacingCharacters(in: range, with: string)
        if replacedString == "" {
            //変更後が空ならばラベルに0を表示する
            myLabel.text = "0"
        } else {
            //変更後の値を計算してラベルに表示する（25を掛けた値）
            if let num = Int(replacedString) {
            myLabel.text = String(num * 25)
            }
        }
        
        return true
    
    
    }
    
    

}

