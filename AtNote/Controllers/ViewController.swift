//
//  ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/03/16.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタン設定
        searchBtn.frame = CGRect(x: 100, y: 100, width: 180, height: 60)
        searchBtn.center = self.view.center
        searchBtn.backgroundColor = .orange
        searchBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        searchBtn.layer.borderWidth = 2
        searchBtn.layer.borderColor = UIColor.brown.cgColor
        searchBtn.layer.cornerRadius = 10
 
    }

    @IBAction func didTouchLocationBtn(_ sender: Any) {
        
        HUD.show(.progress)
        
        //ノートリストへ遷移
        self.performSegue(withIdentifier: "toNoteList", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
