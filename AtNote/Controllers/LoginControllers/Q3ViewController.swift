//
//  Q3ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/10.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit

class Q3ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTouchFacebook(_ sender: Any) {
        selectQ3("Facebook")
    }
    
    @IBAction func didTouchTwitter(_ sender: Any) {
        selectQ3("Twitter")
    }
    
    @IBAction func didTouchInstagram(_ sender: Any) {
        selectQ3("Instagram")
    }
    
    @IBAction func didTouchTikTok(_ sender: Any) {
        selectQ3("Tik Tok")
    }
    
    @IBAction func didTouchOther(_ sender: Any) {
        selectQ3("この中にはない")
    }
    
    func selectQ3(_ answer: String){
        userDefaults.set(answer, forKey: "answer3")
        performSegue(withIdentifier: "toAnswerChk", sender: nil)
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
