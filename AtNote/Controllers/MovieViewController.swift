//
//  MovieViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/04/24.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import PKHUD
import AVFoundation

class MovieViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()

        let pass = userDefaults.object(forKey: "pass") as! String
        let reference = storage.reference().child(pass)
        
        reference.downloadURL { url, error in
            if error == nil {
                let player = AVPlayer(url: url!)
                
                // レイヤーの追加
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(playerLayer)
                
                // 再生
                HUD.hide()
                player.play()
                
            }
        }
        
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
