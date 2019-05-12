//
//  Q2ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/10.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit

class Q2ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTouch10(_ sender: Any) {
        selectQ2("10代以下")
    }
    
    @IBAction func didTouch20(_ sender: Any) {
        selectQ2("20代")
    }
    
    @IBAction func didTouch30(_ sender: Any) {
        selectQ2("30代")
    }
    
    @IBAction func didTouch40(_ sender: Any) {
        selectQ2("40代")
    }
    
    @IBAction func didTouch50(_ sender: Any) {
        selectQ2("50代")
    }
    
    @IBAction func didTouch60(_ sender: Any) {
        selectQ2("60代以上")
    }
    
    func selectQ2(_ answer: String){
        userDefaults.set(answer, forKey: "answer2")
        performSegue(withIdentifier: "toQ3", sender: nil)
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
