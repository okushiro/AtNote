//
//  Login2ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/12.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class Login2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.hide()

        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
                print(error)
            } else {
                // Account deleted.
            }
        }
        
        // Do any additional setup after loading the view.
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
