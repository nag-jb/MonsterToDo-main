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
    
    
    let image = ["monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg", "monster.jpg"]
    
    
    
//MARK: - ロード時に呼び出される処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        userImageView.image = UIImage(named: "heroMan.png")
        
        
        //レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width / 3 - 2, height: self.view.frame.size.width / 3 - 2)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UserDefaults.standard.object(forKey: "userName") as? String{
            userName.text = (UserDefaults.standard.object(forKey: "userName") as! String)
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            let photoData = (UserDefaults.standard.data(forKey: "userImage"))
            userImageView.image = UIImage(data: photoData! as Data)
        }
    }
    
//MARK: - プロフィール
    

//MARK: - 図鑑
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let monster: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "monster", for: indexPath)
        
        //tag番号を使ってImageViewのインスタンス生成
        let ImageView = monster.contentView.viewWithTag(1) as! UIImageView
        
        //画像配列の番号で指定された要素の名前の画像をUIImageとする
        let cellImage = UIImage(named: image[indexPath.row])
        
        //UIImageをUIImageViewのimageとして設定
        ImageView.image = cellImage
        
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
