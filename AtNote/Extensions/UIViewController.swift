//
//  UIViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/04/29.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
extension UIViewController {
    //アラートの関数
    func showAlert(_ text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
