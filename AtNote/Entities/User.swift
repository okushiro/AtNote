//
//  User.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/05/11.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import Foundation
import Firebase

protocol UserDelegate: class {
    func didCreate(error: Error?)
    func didLogin(error: Error?)
}

class User {
    
    static let shared = User()
    
    private var user: FirebaseAuth.User? {
        get {
            return Auth.auth().currentUser
        }
    }
    
    weak var delegate: UserDelegate?
    
    private init() {
    }
    
    func create (credential: Credential) {
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("ユーザー作成成功")
            }
            self.delegate?.didCreate(error: error)
        }
    }
    
    func login (credential: Credential) {
        Auth.auth().signIn(withEmail: credential.email, password: credential.password) { (result, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("ログイン成功")
            }
            self.delegate?.didLogin(error: error)
        }
    }
    
    func logout () {
        try! Auth.auth().signOut()
    }
    
    func isLogin () -> Bool {
        if user != nil {
            return true
        }
        return false
    }
    
    func getUid() -> String?{
        return user?.uid
    }
    
}
