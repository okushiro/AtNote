//
//  NoteViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/04/02.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import PKHUD
import AVFoundation

class NoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    let userDefaults = UserDefaults.standard
    
    let noteList: [String] = UserDefaults.standard.array(forKey: "noteList") as! [String]
    let selectRow = UserDefaults.standard.integer(forKey: "selectRow")
    
    var cellNumber:Int = 0
    var cellText = [String]()
    var cellPicture = [String]()
    var cellMovie = [String]()
    var cellTime = [String]()
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = (self as UICollectionViewDelegate)
        self.collectionView.dataSource = (self as UICollectionViewDataSource)
        
        collectionView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action:
            #selector(handleRefreshControl),
                             for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    //ビューが表示された時
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.collection("shops").document("\(noteList[selectRow])").collection("note").order(by: "createTime", descending: true).getDocuments { (snapshot, error) in
            let targets = snapshot?.documents
            self.cellNumber = targets!.count
            
            self.cellText = [String]()
            self.cellPicture = [String]()
            self.cellMovie = [String]()
            self.cellTime = [String]()
            
            //テキストと写真、動画を取得
            for i in 0 ..< self.cellNumber {
                self.cellText.append(targets![i].data()["text"]! as! String)
                self.cellPicture.append(targets![i].data()["picture"]! as! String)
                self.cellMovie.append(targets![i].data()["movie"]! as! String)
                self.cellTime.append(targets![i].data()["time"]! as! String)
            }
            
            //読み込み
            HUD.hide()
            self.collectionView.reloadData()
        }
        
    }
    
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("タップしました")
        if cellMovie[indexPath.row] != "" {
            HUD.show(.progress)
            let pass = "movie/\(cellMovie[indexPath.row])"
            userDefaults.set(pass, forKey: "pass")
            performSegue(withIdentifier: "toMovie", sender: nil)
            
        }
        
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let comment = cell.contentView.viewWithTag(1) as? UITextView{
            comment.text = cellText[indexPath.row]
            comment.isEditable = false
            comment.isUserInteractionEnabled = false
        }
        
        if let image = cell.contentView.viewWithTag(2) as? UIImageView{
            let storageRef = storage.reference()
            let reference = storageRef.child("picture/\(cellPicture[indexPath.row])")
            image.sd_setImage(with: reference)
            image.isUserInteractionEnabled = false
        }
        
        if let time = cell.contentView.viewWithTag(3) as? UILabel{
            time.text! = cellTime[indexPath.row]
        }
        
        return cell
    }
    
/////////////////////////////////////////////////////////////////////////////////////

    //写真ボタンをタップ
    @IBAction func didTouchPictureBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        //カメラ
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                
                //ビデオも可
                imagePickerController.mediaTypes = ["public.image", "public.movie"]
                imagePickerController.videoQuality = .typeHigh
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        //アルバム
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "アルバム", style: .default, handler: {(action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                
                //ビデオも可
                imagePickerController.mediaTypes = ["public.image", "public.movie"]
                imagePickerController.videoQuality = .typeHigh
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        //キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //撮影終了後
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        HUD.show(.progress)
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        print(mediaType)

        if mediaType == "public.image"{
            //写真を取得した時
            //イメージの取得
            var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            //サイズの変更
            image = image.scaleImage(scaleSize: 0.1)
            
            //画像向きの補正
            let size = image.size
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            let storageRef = storage.reference()
            
            if let data = image.pngData() {
                
                let random = randomString(length: 10)
                let path = "\(random)" + ".png"
                //ストレージに保存
                let reference = storageRef.child("picture/" + path)
                reference.putData(data, metadata: nil, completion: { metaData, error in
                    
                    //firestoreにも保存
                    guard let uid = User.shared.getUid() else{
                        return
                    }
                    
                    var ref: DocumentReference?
                    ref = self.db.collection("shops").document("\(self.noteList[self.selectRow])").collection("note").addDocument(data: [
                        "text": "",
                        "picture": path,
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
                            
                            //写真を追加してノートを読み込み
                            self.cellText.insert("", at:0)
                            self.cellPicture.insert(path, at:0)
                            self.cellMovie.insert("", at:0)
                            self.cellTime.insert("", at:0)
                            
                            self.cellNumber += 1
                            self.collectionView.reloadData()
                            HUD.hide()
                        }
                    }
                })
            }
        }else{
            //動画を取得した時
            if let data = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
                let storageRef = storage.reference()
                let random = randomString(length: 10)
                
                //動画をストレージに保存
                let moviePath = "\(random)" + ".mp4"
                let movieReference = storageRef.child("movie/" + moviePath)
                movieReference.putFile(from:data , metadata: nil, completion: { metaData, error in
                    
                    //サムネイル画像作成
                    let video = AVURLAsset(url: data)
                    let generator = AVAssetImageGenerator(asset: video)
                    
                    let sec = Int(video.duration.seconds)
                    let videoTime = String(format:"%02d:%02d", sec/60, sec%60)
                    
                    var track = video.tracks(withMediaType: AVMediaType.video)
                    let tmpThumb = try! generator.copyCGImage(at: .zero, actualTime: nil)
                    
                    let media = track[0]
                    let naturalSize: CGSize = media.naturalSize
                    let transform: CGAffineTransform = media.preferredTransform
                    
                    var uiImageThumb = UIImage()
                    
                    //画像の向きの取得
                    if transform.tx == naturalSize.width && transform.ty == naturalSize.height {
                        uiImageThumb = UIImage(cgImage: tmpThumb, scale: 1.0, orientation: UIImage.Orientation.down)
                    } else if transform.tx == 0 && transform.ty == 0 {
                        uiImageThumb = UIImage(cgImage: tmpThumb, scale: 1.0, orientation: UIImage.Orientation.up)
                    } else if transform.tx == 0 && transform.ty == naturalSize.width {
                        uiImageThumb = UIImage(cgImage: tmpThumb, scale: 1.0, orientation: UIImage.Orientation.left)
                    } else {
                        uiImageThumb = UIImage(cgImage: tmpThumb, scale: 1.0, orientation: UIImage.Orientation.right)
                    }
                    
                    //サイズの変更
                    uiImageThumb = uiImageThumb.scaleImage(scaleSize: 0.1)
                    
                    //画像向きの補正
                    let size = uiImageThumb.size
                    UIGraphicsBeginImageContext(size)
                    uiImageThumb.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    uiImageThumb = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    
                    let thumbnail = uiImageThumb.pngData()!
                    
                    //サムネイルをストレージに保存
                    let thumbPath = "\(random)" + ".png"
                    let thumbReference = storageRef.child("picture/" + thumbPath)
                    
                    thumbReference.putData(thumbnail, metadata: nil, completion: { metaData, error in
                        
                        //firestoreにも保存
                        var ref: DocumentReference?
                        ref = self.db.collection("shops").document("\(self.noteList[self.selectRow])").collection("note").addDocument(data: [
                            "text": "",
                            "picture": thumbPath,
                            "movie": moviePath,
                            "time": videoTime,
                            "createTime":Date()
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                //ref(DocumentReference)に自動付番されたドキュメントIDが返ってくる
                                print("Document added with ID: \(ref!.documentID)")
                                
                                //写真を追加してノートを読み込み
                                self.cellText.insert("", at:0)
                                self.cellPicture.insert(thumbPath, at:0)
                                self.cellMovie.insert(moviePath, at:0)
                                self.cellTime.insert(videoTime, at:0)
                                self.cellNumber += 1
                                self.collectionView.reloadData()
                                HUD.hide()
                            }
                        }
                        
                    })
                    
                })
            }
        }
        
        //クローズ
        dismiss(animated:true, completion:nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ランダムな文字列を生成
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //refresh controller
    @objc func handleRefreshControl() {
        // Update your content…
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.refreshCtl.endRefreshing()
        }
    }
    
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



