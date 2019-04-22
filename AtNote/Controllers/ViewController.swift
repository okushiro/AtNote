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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
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
