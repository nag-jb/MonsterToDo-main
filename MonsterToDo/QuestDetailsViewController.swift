//
//  QuestDetailsViewController.swift
//  MonsterToDo
//
//  Created by Sallivan James on 2021/03/12.
//

import Foundation
import UIKit

class QuestDetailsViewController: UIViewController {
    
    @IBOutlet var questLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var memoTextView: UITextView!
    
    var quest: String = ""
    var genre: String = ""
    var level: String = ""
    var date: String = ""
    var memo: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questLabel.text = quest
        genreLabel.text = genre
        levelLabel.text = level
        dateLabel.text = date
        memoTextView.text = memo
        
        
        
        
    }
    
}
