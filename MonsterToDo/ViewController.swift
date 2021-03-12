//
//  ViewController.swift
//  MonsterToDo
//
//  Created by Sallivan James on 2021/03/06.
//

import UIKit

//データを表示するための格納箱
var todoQuest = [String]()
var todoGenre = [String]()
var todoLevel = [String]()
var todoExp = [Int]()
var todoDate = [String]()
var todoMemo = [String]()
var todoMonster = [NSData]()

var exp = 100
var expTotal = ""

class ViewController: UIViewController, UITableViewDataSource {
    
    //StoryBoardで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    //ToDoタスクを表示するための配列
    var todoArray = [String]()
    
//MARK: - ロード時に呼び出される処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くという宣言
        table.dataSource = self
        
        //カスタムセルを登録
        self.table.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "questCell")
        configureTableView()
        
        if UserDefaults.standard.object(forKey: "quest") != nil {
            todoQuest = UserDefaults.standard.object(forKey: "quest") as! [String]
            todoDate = UserDefaults.standard.object(forKey: "date") as! [String]
            todoGenre = UserDefaults.standard.object(forKey: "genre") as! [String]
            todoLevel = UserDefaults.standard.object(forKey: "level") as! [String]
            todoExp = UserDefaults.standard.array(forKey: "exp") as! [Int]
            todoMemo = UserDefaults.standard.object(forKey: "memo") as! [String]
            let photoData = UserDefaults.standard.object(forKey: "monster") as! [Data]
            
            todoMonster.removeAll()
            for data in photoData {
                print(data)
                todoMonster.append(data as NSData)
            }
        }
        table.reloadData()
        
        print(todoQuest)
        print(todoGenre)
        print(todoLevel)
        print(todoExp)
        print(todoDate)
        print(todoMemo)
        print("現在のexp：\(exp)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //NavigationBarを透明化
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for : .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        //reload
        table.reloadData()
        print("0")
    }
    
    //MARK: - セル設定
    //セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return todoQuest.count
    }
    
    
    //ID付きのセルを取得し、セル付属のLabelやImageViewに値を代入
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "questCell", for: indexPath) as! ToDoTableViewCell
        cell.fightButton.addTarget(self, action: #selector(ViewController.fight(_:)), for: .touchUpInside)
        
        
        //ボタンにタグを設定
        cell.fightButton.tag = indexPath.row
        
        
        cell.questLabel.text = todoQuest[indexPath.row]
        cell.dateLabel.text = todoDate[indexPath.row]
        cell.lifeLabel.text = String(todoExp[indexPath.row])
        cell.monImageView.image = UIImage(data: todoMonster[indexPath.row] as Data)
        
        print(todoQuest)
        print(todoGenre)
        print(todoLevel)
        print(todoExp)
        print(todoDate)
        print(todoMemo)
        print("現在のexp：\(exp)")
        
        return cell
    }
    
    
    func configureTableView(){
        table.rowHeight = 70
    }
    
//MARK: -スワイプしたセルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //アラートコントローラ：タイトル、メッセージ、アラートスタイルを設定
            let alertController = UIAlertController(title: "クエストを辞退", message: "クエストを辞退しますか？(exp -10)", preferredStyle: .alert)
            
            //アクション：ボタンの文字、ボタンスタイル、ボタンを押した時の処理を設定
            let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            
            //タスクが完了したらTableViewから該当タスクを消去、図鑑に登録
            let okAction = UIAlertAction(title: "はい", style: .default, handler: {(action: UIAlertAction!) in
                
                //expを-10減らす
                exp -= 10
                expTotal = String(describing: exp)
                //userDefaultsへ保存
                UserDefaults.standard.set(expTotal, forKey: "userExp")
                
                //確認alert表示
                self.alertExpHeru()
                
                //クエストを削除
                todoQuest.remove(at: indexPath.row)
                todoDate.remove(at: indexPath.row)
                todoExp.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                //userDefaultsへ書込
                UserDefaults.standard.set(todoQuest, forKey: "quest")
                UserDefaults.standard.set(todoDate, forKey: "date")
                UserDefaults.standard.set(todoExp, forKey: "exp")
                UserDefaults.standard.set(todoMonster, forKey: "monster")
                
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
        print("e")
        print(todoQuest)
        print(todoDate)
    }
    
        
    func alertExpHeru(){
        
        //alertのタイトル、本文部分を作成
        let alert: UIAlertController = UIAlertController(title: "クエスト削除", message: "expが10減りました", preferredStyle: .alert)
        //alertのボタン部分を設定
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
        //alert表示
        present(alert, animated: true, completion: nil)
        }
    
    //MARK: - タスク完了アクション
    //タスクの完了を設定
    @IBAction func fight(_ sender: UIButton){
        
        //Int型からIndexPath型にキャスト
        let indexPath = IndexPath(row: sender.tag, section: 0)
        //indexPath型でセルを指定可能
        //let cell = self.table.cellForRow(at: indexPath)
        
        //アラートコントローラ：タイトル、メッセージ、アラートスタイルを設定
        let alertController = UIAlertController(title: "モンスターと戦う", message: "タスクを完了しましたか？", preferredStyle: .alert)
        
        //アクション：ボタンの文字、ボタンスタイル、ボタンを押した時の処理を設定
        let cancelAction = UIAlertAction(title: "苦戦中...", style: .cancel, handler: nil)
        
        //タスクが完了したらTableViewから該当タスクを消去
        let okAction = UIAlertAction(title: "任務完了", style: .default, handler: {(action: UIAlertAction!) in
            
            //expを獲得
            exp += todoExp[indexPath.row]
            expTotal = String(describing: exp)
            //userDefaultsへ保存
            UserDefaults.standard.set(expTotal, forKey: "userExp")
            
            //alertのタイトル、本文部分を作成
            let alert: UIAlertController = UIAlertController(title: " クエスト完了", message: "expを獲得しました", preferredStyle: .alert)
            //alertのボタン部分を設定
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
            //alert表示
            self.present(alert, animated: true, completion: nil)
            
            todoQuest.remove(at: indexPath.row)
            todoDate.remove(at: indexPath.row)
            todoGenre.remove(at: indexPath.row)
            todoLevel.remove(at: indexPath.row)
            todoExp.remove(at: indexPath.row)
            todoMemo.remove(at: indexPath.row)
            todoMonster.remove(at: indexPath.row)
            
            self.table.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //userDefaultsへ書込
            UserDefaults.standard.set(todoQuest, forKey: "quest")
            UserDefaults.standard.set(todoDate, forKey: "date")
            UserDefaults.standard.set(todoGenre, forKey: "genre")
            UserDefaults.standard.set(todoLevel, forKey: "level")
            UserDefaults.standard.set(todoExp, forKey: "exp")
            UserDefaults.standard.set(todoMemo, forKey: "memo")
            UserDefaults.standard.set(todoMonster, forKey: "monster")
            
            
            print(todoQuest)
            print(todoDate)
            print(todoGenre)
            print(todoLevel)
            print(todoExp)
            print(todoMemo)
            print("現在のexp：\(exp)")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        print("pushed Button")
    }

}

