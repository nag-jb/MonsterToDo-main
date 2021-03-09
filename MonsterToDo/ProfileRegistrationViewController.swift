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

    let userPhoto = ["heroMan.png", "heroWoman.png", "kenja.png", "salary.png", "daran.png", "boxer.png", "jk.png", "kid.png", ]
    var changeImgNo = 0
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.image = UIImage(named: "heroMan.png")
        
        userNameTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Changeボタン
    @IBAction func change(){
        if changeImgNo == 0 {
            changeImgNo = 1
        }else if changeImgNo == 1 {
            changeImgNo = 2
        }else if changeImgNo == 2 {
            changeImgNo = 3
        }else if changeImgNo == 3 {
            changeImgNo = 4
        }else if changeImgNo == 4 {
            changeImgNo = 5
        }else if changeImgNo == 5 {
            changeImgNo = 6
        }else if changeImgNo == 6 {
            changeImgNo = 7
        }else if changeImgNo == 7 {
            changeImgNo = 0
        }
        let photoName = userPhoto[changeImgNo]
        userImageView.image = UIImage(named: photoName)
        photo = UIImage(named: photoName)
    }
    
    
    //MARK: - saveボタン
    @IBAction func save(){
        
        //UIImageをData型へ変換
        let data = photo.pngData() as NSData?
        
        
        //userDefaultsへ保存
        saveData.set(userNameTextField.text, forKey: "userName")
        saveData.set(data, forKey: "userImage")
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
