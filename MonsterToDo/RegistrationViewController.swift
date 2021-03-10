//
//  RegistrationViewController.swift
//  MonsterToDo
//
//  Created by Sallivan James on 2021/03/06.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    
    @IBOutlet var questTextField: UITextField!
    @IBOutlet var genreTextField: UITextField!
    @IBOutlet var levelTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var saveTask: UIButton!
    
    var genrePickerView: UIPickerView = UIPickerView()
    var levelPickerView: UIPickerView = UIPickerView()
    var datePicker: UIDatePicker = UIDatePicker()
    
    let genreList: [String] = ["課題", "テスト", "その他"]
    let levelList: [String] = ["Easy", "Normal", "Hard"]
    
    var monsterImage: UIImage!
    var changeImageNo = 0
    let image = ["slime.png", "monster.jpg", "dragon.png"]
    
    //ユーザデフォルトにアクセスするための倉庫を作成
    var saveDate: UserDefaults = UserDefaults.standard

//MARK: - ロード時に呼び出される処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questTextField.delegate = self
        genreTextField.delegate = self
        levelTextField.delegate = self
        dateTextField.delegate = self
        memoTextView.delegate = self
        saveTask.isEnabled = false
        
        //日付のpicker
        setupToolbar()
        //ジャンル、レベルのpicker
        createPickerView()
        //textViewのキーボード非表示機能
        textViewshouldDone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNotificationForTextField()
    }
    
//MARK: - 日付のpicker設定
    func setupToolbar(){
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .wheels
        
        let dateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let dateSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dateDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDone))
            dateToolbar.setItems([dateSpaceItem, dateDoneItem], animated: true)
            
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = dateToolbar
    }
    
    //MARK: - ジャンル、レベルのpicker設定
    func createPickerView(){
        //picker設定@genre
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        
        //決定バーの生成
        let genreToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let genreSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let genreDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(genreDone))
        genreToolbar.setItems([genreSpaceItem, genreDoneItem], animated: true)
        
        //インプットビュー設定
        genreTextField.inputView = genrePickerView
        genreTextField.inputAccessoryView = genreToolbar
        
        
        //picker設定@level
        levelPickerView.delegate = self
        levelPickerView.dataSource = self
        
        //決定バーの生成
        let levelToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let levelSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let levelDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(levelDone))
        levelToolbar.setItems([levelSpaceItem, levelDoneItem], animated: true)
        
        //インプットビュー設定
        levelTextField.inputView = levelPickerView
        levelTextField.inputAccessoryView = levelToolbar
    }
    
    //MARK: - picker終了
    @objc func genreDone(){
        genreTextField.endEditing(true)
        genreTextField.text = "\(genreList[genrePickerView.selectedRow(inComponent: 0)])"
    }
    
    @objc func levelDone(){
        levelTextField.endEditing(true)
        levelTextField.text = "\(levelList[levelPickerView.selectedRow(inComponent: 0)])"
    }
    
    //日付picker終了
    @objc func dateDone(){
        dateTextField.endEditing(true)
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd  HH:mm"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func memoDone(){
        self.view.endEditing(true)
    }
    
    //UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView{
            return genreList.count
        }else{
            return levelList.count
        }
    }
    
    
    //UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView{
            return genreList[row]
        }else{
            return levelList[row]
        }
    }
    
    //値を代入
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerView{
            genreTextField.text = genreList[row]
           
        }else{
            self.levelTextField.text = levelList[row]
        }
        var hoge = "a"
        
        //難易度毎にモンスター画像を変更
        if levelTextField.text == levelList[0] {
            changeImageNo = 0
            hoge = "slime"
        }else if levelTextField.text == levelList[1]{
            changeImageNo = 1
            hoge = "monster"
        }else {
            changeImageNo = 2
            hoge = "dragon"
        }
        monsterImage = UIImage(named: image[changeImageNo])
        print(hoge)
    }
    
//MARK: - キーボードが隠れないようにする
    func setUpNotificationForTextField() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo //この中にキーボードの情報がある
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.memoTextView?.frame.origin.y)!
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            
        }
    }
    
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    
    //MARK: - saveボタン
    @IBAction func save(){
        
        //タスク名を変数に格納、その後フィールドを空にする
        todoQuest.append(questTextField.text!)
        questTextField.text = ""
        
        //ジャンルを変数に格納、その後フィールドを空にする
        todoGenre.append(genreTextField.text!)
        genreTextField.text = ""
        
        //難易度を変数に格納、その後フィールドを空にする
        todoLevel.append(levelTextField.text!)
        levelTextField.text = ""
        //難易度にあったモンスタ画像を格納
        sendSaveImage()
        
        
        todoDate.append(dateTextField.text!)
        dateTextField.text = ""
        
        //メモを変数に格納、その後フィールドを空にする
        todoMemo.append(memoTextView.text!)
        memoTextView.text = ""
        
        //todoMonster.append(monsterImage)
        
        
        //userDefaultsに書込
        saveDate.set(todoQuest, forKey: "quest")
        saveDate.set(todoGenre, forKey: "genre")
        saveDate.set(todoLevel, forKey: "level")
        saveDate.set(todoDate, forKey: "date")
        saveDate.set(todoMemo, forKey: "memo")
        saveDate.set(todoMonster, forKey: "monster")
        
        saveDate.synchronize()
        
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
        print()
    }
    

    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK: - 画像保存
    func sendSaveImage(){
        //NSDate型にキャスト
        let data = monsterImage.pngData() as NSData?
        if let imageData = data {
            todoMonster.append(imageData)
            saveDate.set(todoMonster, forKey: "monster")
            print("画像保存完了")
            
        }
    }

//MARK: - ボタン効果
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
            self.saveTask.isEnabled = !(self.questTextField.text?.isEmpty ?? true)
        }
        return true
    }
    
    
    //MARK: - キーボード非表示機能
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        //TextFieldのファーストレスポンダを止める
        textField.resignFirstResponder()
        return true
    }
    
    //textViewのキーボード非表示機能
    func textViewshouldDone(){
        
        let memoToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        memoToolbar.barStyle = UIBarStyle.default
        memoToolbar.sizeToFit()
        let memoSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let memoDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(memoDone))
        memoToolbar.setItems([memoSpaceItem, memoDoneItem], animated: true)
        memoTextView.inputAccessoryView = memoToolbar
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
