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
var todoDate = [String]()
var todoMemo = [String]()
var todoMonster = [UIImageView]()

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
            //todoMonster = UserDefaults.standard.object(forKey: "monster") as! [UIImageView]
            
        }
        
        print(todoQuest)
        print(todoGenre)
        print(todoLevel)
        print(todoDate)
        print(todoMemo)
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
        //cell.monImageView = todoMonster[indexPath.row]
        
        print(todoQuest)
        print(todoGenre)
        print(todoLevel)
        print(todoDate)
        print(todoMemo)
        
        return cell
    }
    
    
    func configureTableView(){
        table.rowHeight = 70
    }
    
//MARK: -スワイプしたセルの削除
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete{
//            todoQuest.remove(at: indexPath.row)
//            todoDate.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
//            //userDefaultsへ書込
//            UserDefaults.standard.set(todoQuest, forKey: "quest")
//            UserDefaults.standard.set(todoDate, forKey: "date")
//            UserDefaults.standard.set(todoMonster, forKey: "monster")
//        }
//
//        print("e")
//        print(todoQuest)
//        print(todoDate)
//    }
    
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
        
        
        
        //タスクが完了したらTableViewから該当タスクを消去、図鑑に登録
        let okAction = UIAlertAction(title: "任務完了", style: .default, handler: {(action: UIAlertAction!) in
            todoQuest.remove(at: indexPath.row)
            todoDate.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //userDefaultsへ書込
            UserDefaults.standard.set(todoQuest, forKey: "quest")
            UserDefaults.standard.set(todoDate, forKey: "date")
            
            print(todoQuest)
            print(todoDate)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        print("pushed Button")
    }
    

}

