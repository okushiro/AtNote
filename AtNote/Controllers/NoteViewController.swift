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

class NoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firestore.firestore()
    let noteList: [String] = UserDefaults.standard.array(forKey: "noteList") as! [String]
    let selectRow = UserDefaults.standard.integer(forKey: "selectRow")
    
    var cellNumber:Int = 0
    var cellText = [String]()
    var cellPicture = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = (self as UICollectionViewDelegate)
        self.collectionView.dataSource = (self as UICollectionViewDataSource)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.collection("shops").document("\(noteList[selectRow])").collection("note").getDocuments { (snapshot, error) in
            let targets = snapshot?.documents
            self.cellNumber = targets!.count
            
            self.cellText = [String]()
            self.cellPicture = [String]()
            
            //テキストと写真を取得
            for i in 0 ..< self.cellNumber {
                self.cellText.append(targets![i].data()["text"]! as! String)
                self.cellPicture.append(targets![i].data()["picture"]! as! String)
            }
            
            print(self.cellNumber)
            print(self.cellText)
            //読み込み
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let label = cell.contentView.viewWithTag(1) as? UITextView{
            label.text = cellText[indexPath.row]
            label.isEditable = false
        }
        
        if let image = cell.contentView.viewWithTag(2) as? UIImageView{
            let storageRef = Storage.storage().reference()
            let reference = storageRef.child("picture/\(cellPicture[indexPath.row])")
            image.sd_setImage(with: reference)
        }
        
        return cell
    }
    
    
    //写真ボタンをタップ
    @IBAction func didTouchPictureBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        //カメラ
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
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
        
        let storage = Storage.storage()
        let starageRef = storage.reference()
        
        if let data = image.pngData() {
        
            let random = randomString(length: 10)
            let path = "\(random)" + ".png"
            //保存
            let reference = starageRef.child("picture/" + path)
            reference.putData(data, metadata: nil, completion: { metaData, error in
                print(metaData as Any)
                print(error as Any)
                
                //firestoreにも保存
                var ref: DocumentReference?
                ref = self.db.collection("shops").document("\(self.noteList[self.selectRow])").collection("note").addDocument(data: [
                    "text": "",
                    "picture": path
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        //ref(DocumentReference)に自動付番されたドキュメントIDが返ってくる
                        print("Document added with ID: \(ref!.documentID)")
                        self.cellText.append("")
                        self.cellPicture.append(path)
                        self.cellNumber += 1
                        self.collectionView.reloadData()
                    }
                }
            })
            
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


extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
