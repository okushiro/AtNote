//
//  CommentViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/04/08.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    let db = Firestore.firestore()
    let noteList: [String] = UserDefaults.standard.array(forKey: "noteList") as! [String]
    let selectRow = UserDefaults.standard.integer(forKey: "selectRow")

    @IBOutlet weak var CommentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchCommentBtn(_ sender: Any) {
        
        guard let title = CommentTextView.text else {
            return
        }
        if (title.isEmpty) {
            showAlert("コメントを入力して下さい。")
            return
        }
        
        guard let uid = User.shared.getUid() else{
            return
        }
        
        var ref: DocumentReference?
        ref = db.collection("shops").document("\(noteList[selectRow])").collection("note").addDocument(data: [
            "text": title,
            "picture": "",
            "movie": "",
            "time": "",
            "userID": uid,
            "createTime":Date()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                //ref(DocumentReference)に自動付番されたドキュメントIDが返ってくる
                print("Document added with ID: \(ref!.documentID)")
                //画面遷移
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    //キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
