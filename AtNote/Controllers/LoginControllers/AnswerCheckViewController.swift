//
//  AnswerCheckViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/10.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class AnswerCheckViewController: UIViewController, UserDelegate {
    
    let user = User.shared
    
    let userDefaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer2Label: UILabel!
    @IBOutlet weak var answer3Label: UILabel!
    
    var answer1:String = ""
    var answer2:String = ""
    var answer3:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.delegate = self
        
        answer1 = userDefaults.object(forKey: "answer1") as! String
        answer2 = userDefaults.object(forKey: "answer2") as! String
        answer3 = userDefaults.object(forKey: "answer3") as! String
        
        answer1Label.text = answer1
        answer2Label.text = answer2
        answer3Label.text = answer3

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTouchCompleteBtn(_ sender: Any) {
        
        HUD.show(.progress)
        
        let email = userDefaults.object(forKey: "mail") as! String
        let password = userDefaults.object(forKey: "password") as! String
        let credential = Credential(email:email, password:password)
        
        user.create(credential: credential)
    }
    
    
    // delegate
    func didCreate(error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        //firestoreにユーザー情報を保存
        if let uid = User.shared.getUid(){
            var ref: DocumentReference?
            ref = db.collection("users").document(uid).collection("profile").addDocument(data: [
                "sex": answer1,
                "age": answer2,
                "sns": answer3
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    //ref(DocumentReference)に自動付番されたドキュメントIDが返ってくる
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        
        //Storyboardを移動
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        self.present(viewController, animated: true, completion: nil)
    }
    // delegate
    func didLogin(error: Error?) {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
