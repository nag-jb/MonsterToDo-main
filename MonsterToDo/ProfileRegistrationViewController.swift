//
//  ProfileRegistrationViewController.swift
//  MonsterToDo
//
//  Created by Sallivan James on 2021/03/08.
//

import UIKit

class ProfileRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    
    
    var saveData: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Changeボタン
    @IBAction func change(){
        
    }
    
    
    //MARK: - saveボタン
    @IBAction func save(){
        
        
        
        saveData.set(userNameTextField.text, forKey: "userName")
        //saveData.set(userImageView, forKey: "userImage")
        saveData.synchronize()
        
        //alertを出す
        let alert: UIAlertController = UIAlertController(title: "保存", message: "プロフィールが更新されました", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Returnボタンでキーボード非表示
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
