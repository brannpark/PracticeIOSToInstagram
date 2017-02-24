//
//  TableViewController.swift
//  PracticeIOSToInstagram
//
//  Created by Masher Shin on 24/02/2017.
//  Copyright © 2017 Masher Shin. All rights reserved.
//

import UIKit
import Alamofire
import InstagramKit
import AFNetworking

class TableViewController: UITableViewController {
    
    var data: [InstagramMedia] = []
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yy/MM/dd"
        dateFormatter.timeZone = TimeZone(identifier: "Seoul/Asia")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let accessToken = InstagramEngine.shared().accessToken,
            accessToken.characters.count > 0 && InstagramEngine.shared().isSessionValid() {
            //37.498300, 127.027788
            print(accessToken)
            InstagramEngine.shared().getMediaAtLocation(CLLocationCoordinate2DMake(37.4983, 127.0277), count: 100, maxId: nil, distance: 3000, withSuccess: { [weak self] ( items, paginationInfo) in
                
                print(items)
                DispatchQueue.global(qos: .default).async { [weak self] in
                    let filteredItems = self?.filteringByGourmet(items)
                    self?.displayItems(filteredItems)
                }
                
                }, failure: { [weak self] (err, code) in
                    print(err)
                    print(code)
            })
            
        } else {
            performSegue(withIdentifier: "loginIdentifier", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayItems(_ items: [InstagramMedia]?) {
        DispatchQueue.main.async { [weak self] in
//            self?.tableView.isHidden = false
            self?.data = items ?? []
            self?.tableView.reloadData()
        }
    }
    
    
    func filteringByGourmet(_ items: [InstagramMedia]) -> [InstagramMedia] {
        return items.filter { ($0.caption?.text.contains("#맛집"))! }
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! IngMuckCell
        cell.userImageView.layer.borderColor = UIColor.black.cgColor
        
        
        let item = data[indexPath.row]
        let ratio = cell.photoImageView.frame.width / item.standardResolutionImageFrameSize.width
        
        cell.userLabel.text = item.user.fullName
        cell.dateLabel.text = "@" + (item.locationName ?? "Anywhere") + " " + dateFormatter.string(from: item.createdDate)
        cell.captionLabel.text = item.caption?.text
        cell.photoContainerView.constraints.first?.constant = ratio * item.standardResolutionImageFrameSize.height
        
        cell.photoImageView.setImageWith(item.standardResolutionImageURL)
        
        if let userImageUrl = item.user.profilePictureURL {
            cell.userImageView.setImageWith(userImageUrl)
        } else {
            cell.userImageView.image = nil
        }
        
        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
