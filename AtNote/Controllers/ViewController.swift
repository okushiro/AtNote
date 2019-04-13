//
//  ViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/03/16.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    @IBAction func didTouchLocationBtn(_ sender: Any) {
        
        HUD.show(.progress)
        
        //ノートリストへ遷移
        self.performSegue(withIdentifier: "toNoteList", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


/*
 メモ
 
 //画像
 let storageRef = Storage.storage().reference()
 let reference = storageRef.child("picture/apple.png")
 image.sd_setImage(with: reference)
 print(reference)
 */

/*
 //動画
 // 動画ファイルのURLを取得
 let url = URL(string: "gs://atnote-240c2.appspot.com/movie/movie1.mp4")
 
 // 生成
 let player = AVPlayer(url: url!)
 
 // レイヤーの追加
 let playerLayer = AVPlayerLayer(player: player)
 playerLayer.frame = self.view.bounds
 self.view.layer.addSublayer(playerLayer)
 
 // 再生
 player.play()
 */
