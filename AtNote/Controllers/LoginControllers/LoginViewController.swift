//
//  LoginViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/10.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController, UserDelegate {
    
    let user = User.shared
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.delegate = self
        
        //背景画像
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "cafe.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)

        // Do any additional setup after loading the view.
    }
    
    
    // delegate
    func didCreate(error: Error?) {
        if let error = error {
            HUD.hide()
            showAlert(error.localizedDescription)
            return
        }
        performSegue(withIdentifier: "toQuestion", sender: nil)
    }
    // delegate
    func didLogin(error: Error?) {
        if let error = error {
            HUD.hide()
            showAlert(error.localizedDescription)
            return
        }
        //Storyboardを移動
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func didTouchLoginBtn(_ sender: Any) {
        HUD.show(.progress)
        if let credential = getCredential() {
            user.login(credential: credential)
        }
    }
    
    @IBAction func didTouchRegisterBtn(_ sender: Any) {
        HUD.show(.progress)
        if let credential = getCredential() {
            user.create(credential: credential)
        }
        userDefaults.set(mail.text, forKey: "mail")
        userDefaults.set(password.text, forKey: "password")
    }
    
    
    //メアドとパスワードを取得
    func getCredential() -> Credential?{
        let email = self.mail.text!
        let password = self.password.text!
        if (email.isEmpty) {
            HUD.hide()
            showAlert("メールアドレスを入力してください")
            return nil
        }
        if (password.isEmpty) {
            HUD.hide()
            showAlert("パスワードを入力してください")
            return nil
        }
        return Credential(email: email, password: password)
    }
}
