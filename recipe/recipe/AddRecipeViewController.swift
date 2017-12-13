//
//  AddRecipeViewController.swift
//  recipe
//
//  Created by mao takagai on 2017/07/08.
//  Copyright © 2017 mao takagai. All rights reserved.
//

import UIKit
import RealmSwift
import AssetsLibrary

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    @IBOutlet weak var imageView: UIImageView!
    
    //カメラロールから画像を選択
    @IBAction func chooseImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //写真を選択するビュー
            let pickerView = UIImagePickerController()
            //写真の選択元をカメラロールにする（.cameraにすればカメラを起動）
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func resetImage(_ sender: Any) {
        //アラートで確認
        let alert = UIAlertController(title: "確認", message: "削除しますか？", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in
            //デフォルトの画像
            self.imageView.image = UIImage(named: "defaultImage.png")
        })
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //アラートにボタンを追加
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        //アラートを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var recipeNameField: UITextField!

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var materialField: UITextField!
    @IBOutlet weak var dateSelecter: UITextField!
    
    let nowDate = Date()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    var image:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "defaultImage.png")
        
        dateFormat.dateFormat = "yyyy年MM月dd日"
        dateSelecter.text = dateFormat.string(from: nowDate)
        self.dateSelecter.delegate = self
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        dateSelecter.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-20))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackOpaque
        pickerToolBar.tintColor = UIColor.white
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: nil)
        
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.toolBarBtnPush(sender:)))
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn, toolBarBtn]
        dateSelecter.inputAccessoryView = pickerToolBar
        
        

    }
    
    func toolBarBtnPush(sender: UIBarButtonItem){
        
        let pickerDate = inputDatePicker.date
        dateSelecter.text = dateFormat.string(from: pickerDate)
        
        self.view.endEditing(true)
    }

    
    @IBAction func onTapDoneButton(_ sender: Any) {
        let dateStr = dateSelecter.text ?? ""
        let recipeName = recipeNameField.text ?? ""
        let comment = commentField.text ?? ""
        let material = materialField.text ?? ""
        
        if (recipeName.isEmpty) {
            print("nil だよ〜")
            presentAlert()
            return
        }
        
        let recipe = Recipe()
        recipe.date = dateFormat.date(from: dateStr)!
        recipe.name = recipeName
        recipe.comment = comment
        recipe.image = self.image
        
        let realmMaterial = RealmString()
        realmMaterial.value = material
        recipe.materials.append(realmMaterial)
        save(recipe)
        print(recipe)
        print(self.image ?? "画像なし")

        navigationController?.popViewController(animated: true)
       
    }
    
    func save(_ recipe: Recipe) -> Void {
        recipe.save()
    }
    
    func presentAlert() {
        let alert = UIAlertController.init(
            title: "ダメだよ〜",
            message: "料理名だけは入れてね〜",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    //写真を選んだ後に実行される処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //選択された画像を取得
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //ビューに表示
        self.imageView.image = image
        // 画像のパスを取得
        let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
        let recipe = Recipe()
        recipe.image = imageUrl?.absoluteString
        self.image = recipe.image
        print(recipe.image ?? "中身なし")
        
        //写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        
    }
    
    
    
    
}

