//
//  NoteListTableViewController.swift
//  AtNote
//
//  Created by 奥城健太郎 on 2019/03/17.
//  Copyright © 2019 奥城健太郎. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import PKHUD

class NoteListTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var noteList = [String]()
    var currentLatitude : Double = 0
    var currentLongitude : Double = 0
    let userDefaults = UserDefaults.standard
    
    fileprivate let refreshCtl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //位置情報を取得
        setupLocationManager()
        
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action:
            #selector(handleRefreshControl),
                             for: .valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        //データを取得して並べる
        
        let db = Firestore.firestore()
        
        let ref = db.collection("shops").document("\(noteList[indexPath.row])")
        
        ref.getDocument(){(document, err) in
            if let document = document {
                cell.textLabel?.text = (document.data()!["name"] as! String)
            }else{
                print("Document does not exist")
            }
        }
        
        return cell
    }
    
    // セルの選択
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        //選択した行
        userDefaults.set(indexPath.row, forKey: "selectRow")
        //ページ遷移
        performSegue(withIdentifier: "toNote", sender: nil)
    }
    

    //位置情報取得関数
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10000
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        currentLatitude = (location?.coordinate.latitude)!
        currentLongitude = (location?.coordinate.longitude)!
        
        print("------- \n latitude: \(currentLatitude) \n longitude: \(currentLongitude)")
        
        let db = Firestore.firestore()
        
        db.collection("shops").getDocuments { (snapshot, error) in
            let targets = snapshot?.documents
            self.noteList = []
            if let length = targets?.count{
                for i in 0 ..< length {
                    //ノートの位置情報
                    let noteLatitude = targets![i].data()["latitude"]! as! Double
                    let noteLongitude = targets![i].data()["longitude"]! as! Double
                    //計算
                    let latDiff = fabs(noteLatitude - self.currentLatitude)
                    let lonDiff = fabs(noteLongitude - self.currentLongitude)
                    
                    if latDiff < 0.001 && lonDiff < 0.01 {
                        self.noteList.append(targets![i].data()["name"]! as! String)
                    }
                }
            }
            self.userDefaults.set(self.noteList, forKey: "noteList")
            self.tableView.reloadData()
            HUD.hide()
        }
    }

    @objc func handleRefreshControl() {
        // Update your content…
        setupLocationManager()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.refreshCtl.endRefreshing()
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
