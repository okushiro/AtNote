//
//  Q1ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/10.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit

class Q1ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchMan(_ sender: Any) {
        selectQ1("男性")
    }
    
    @IBAction func didTouchWoman(_ sender: Any) {
        selectQ1("女性")
    }
    
    func selectQ1(_ answer: String){
        userDefaults.set(answer, forKey: "answer1")
        performSegue(withIdentifier: "toQ2", sender: nil)
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
