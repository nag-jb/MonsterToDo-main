//
//  ProfileViewController.swift
//  MonsterToDo
//
//  Created by Sallivan James on 2021/03/07.
//

import UIKit



class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //プロフィール
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userExp: UILabel!
    
    //図鑑
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var colletctionViewFlowLayout: UICollectionViewFlowLayout!
    var endQuest = [String]()
    var endMonster = [NSData]()

    
    
    let image = ["monster.jpg", "dragon.png","monster.jpg", "slime.png"]
    
    //ユーザデフォルトにアクセスするための倉庫を作成
    var saveDate: UserDefaults = UserDefaults.standard
    
    
//MARK: - ロード時に呼び出される処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self        
        
        //レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width / 3 - 2, height: self.view.frame.size.width / 3 - 2)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        //図鑑情報
        //画像
//        if saveDate.object(forKey: "endQuest") != nil {
//            endQuest = saveDate.object(forKey: "endQuest") as! [String]
//            //endMonster = saveDate.object(forKey: "endMonster") as! [NSData]
//
//            print(endQuest)
            
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //プロフィール情報
        //経験値
        if let _ = saveDate.object(forKey: "userExp") as? String {
            userExp.text = (saveDate.object(forKey: "userExp") as! String)
        }
        //名前
        if let _ = saveDate.object(forKey: "userName") as? String {
            userName.text = (saveDate.object(forKey: "userName") as! String)
        }
        //画像
        if saveDate.object(forKey: "userImage") != nil {
            let photoData = (saveDate.data(forKey: "userImage"))
            userImageView.image = UIImage(data: photoData! as Data)
        }
        
    }
    
//MARK: - プロフィール
    

//MARK: - 図鑑 collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let monster: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "monster", for: indexPath)
        
        //tag番号を使ってImageViewのインスタンス生成
        //let ImageView = monster.contentView.viewWithTag(1) as! UIImageView
        //let Label = monster.contentView.viewWithTag(2) as! UILabel
        
        //画像配列の番号で指定された要素の名前の画像をUIImageとする
        //ImageView.image = UIImage(data: endMonster[indexPath.row] as Data)
        //ImageView.image = UIImage(named: image[indexPath.row])
        //Label.text = endQuest[indexPath.row]
        
        
        return monster
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //sectionの数は1つ
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //要素数を入れる、要素異常の数字を入れると表示でエラーになる
        return image.count
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
