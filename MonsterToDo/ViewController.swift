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

var nextQuest: String!
var nextGenre: String!
var nextLevel: String!
var nextDate: String!
var nextMemo: String!

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //StoryBoardで扱うTableViewを宣言
    @IBOutlet var table: UITableView!
    
    //ToDoタスクを表示するための配列
    var todoArray = [String]()
    
    //ユーザデフォルトにアクセスするための倉庫を作成
    var saveDate: UserDefaults = UserDefaults.standard
    
//MARK: - ロード時に呼び出される処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くという宣言
        table.dataSource = self
        table.delegate = self
        
        //カスタムセルを登録
        self.table.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "questCell")
        configureTableView()
        
        if UserDefaults.standard.object(forKey: "quest") != nil {
            todoQuest = saveDate.object(forKey: "quest") as! [String]
            todoDate = saveDate.object(forKey: "date") as! [String]
            todoGenre = saveDate.object(forKey: "genre") as! [String]
            todoLevel = saveDate.object(forKey: "level") as! [String]
            todoExp = saveDate.array(forKey: "exp") as! [Int]
            todoMemo = saveDate.object(forKey: "memo") as! [String]
            let photoData = saveDate.object(forKey: "monster") as! [Data]
            
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
        
        if todoGenre[indexPath.row] == "課題" {
            cell.contentView.backgroundColor = UIColor(red: 255 / 255, green: 191 /  255, blue: 166 / 255, alpha: 0.8)
        }else if todoGenre[indexPath.row] == "テスト" {
            cell.contentView.backgroundColor = UIColor(red: 255 / 255, green: 247 /  255, blue: 147 / 255, alpha: 0.5)
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        print(todoQuest)
        print(todoGenre)
        print(todoLevel)
        print(todoExp)
        print(todoDate)
        print(todoMemo)
        print("現在のexp：\(exp)")
        
        return cell
    }
    
    
    //セルの高さを指定
    func configureTableView(){
        table.rowHeight = 70
    }
    
    
    //セル詳細画面への遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        nextQuest = todoQuest[indexPath.row]
        nextGenre = todoGenre[indexPath.row]
        nextLevel = todoLevel[indexPath.row]
        nextDate = todoDate[indexPath.row]
        nextMemo = todoMemo[indexPath.row]
        print("移動するよ")
        
        if nextQuest != nil{
            print("移動するよ2")
            //別の画面に遷移
            performSegue(withIdentifier: "toDetails", sender: nextQuest)
            
        }
    }
   
    //Segue実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //Segueの識別子確認
        if segue.identifier == "toDetails" {
            let questVC: QuestDetailsViewController = segue.destination as! QuestDetailsViewController
            print("wow")
            //遷移先ViewControllerの取得
            questVC.quest = nextQuest
            questVC.genre = nextGenre
            questVC.level = nextLevel
            questVC.date = nextDate
            questVC.memo = nextMemo
        }
    }
    
    
//MARK: - タスクの削除アクション
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if exp >= 10 {
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
                    self.saveDate.set(expTotal, forKey: "userExp")
                    
                    //確認alert表示
                    self.alertExpHeru()
                    
                    //クエストを削除
                    todoQuest.remove(at: indexPath.row)
                    todoGenre.remove(at: indexPath.row)
                    todoLevel.remove(at: indexPath.row)
                    todoDate.remove(at: indexPath.row)
                    todoMemo.remove(at: indexPath.row)
                    todoMonster.remove(at: indexPath.row)
                    
                    todoExp.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                    //userDefaultsへ書込
                    self.saveDate.set(todoQuest, forKey: "quest")
                    self.saveDate.set(todoGenre, forKey: "genre")
                    self.saveDate.set(todoLevel, forKey: "level")
                    self.saveDate.set(todoDate, forKey: "date")
                    self.saveDate.set(todoExp, forKey: "exp")
                    self.saveDate.set(todoMonster, forKey: "monster")
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                print("e")
                print(todoQuest)
                print(todoDate)
            }else{
                //alertを出す
                let alert: UIAlertController = UIAlertController(title: "削除できません", message: "expが足りないため削除できません", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //経験値増えましたよアラート
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
            self.saveDate.set(expTotal, forKey: "userExp")
            
            //alertのタイトル、本文部分を作成
            let alert: UIAlertController = UIAlertController(title: " クエスト完了", message: "expを獲得しました", preferredStyle: .alert)
            //alertのボタン部分を設定
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
            //alert表示
            self.present(alert, animated: true, completion: nil)
            
            //collectionViewへ情報を渡す
//            let endQ = todoQuest[indexPath.row]
            //let endM = todoMonster[indexPath.row]
            self.saveDate.set(todoQuest[indexPath.row], forKey: "endQuest")
            //self.saveDate.set(endM, forKey: "endMonster")
            
//            print("endQ = \(endQ)")
            //print("endM = \(endM)")
            
            
            
            //tableCellから削除
            todoQuest.remove(at: indexPath.row)
            todoDate.remove(at: indexPath.row)
            todoGenre.remove(at: indexPath.row)
            todoLevel.remove(at: indexPath.row)
            todoExp.remove(at: indexPath.row)
            todoMemo.remove(at: indexPath.row)
            todoMonster.remove(at: indexPath.row)
            
            self.table.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //userDefaultsへ書込
            self.saveDate.set(todoQuest, forKey: "quest")
            self.saveDate.set(todoDate, forKey: "date")
            self.saveDate.set(todoGenre, forKey: "genre")
            self.saveDate.set(todoLevel, forKey: "level")
            self.saveDate.set(todoExp, forKey: "exp")
            self.saveDate.set(todoMemo, forKey: "memo")
            self.saveDate.set(todoMonster, forKey: "monster")
            
            
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

