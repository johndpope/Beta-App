//
//  SideMenuTableViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/22/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    // MARK: Properties
    var sideMenuViews: [String] =
    ["Announcements",
    "Notifications",
    "Calendar",
    "Fines",
    "Dishes",
    "Sober Duty",
    "Study Hours",
    "Social",
    "Messaging",
    "Exec Requests",
    "Community Service",
    "Philanthropy",
    "Beta Songs",
    "Bylaws"
    ]
    
    @IBOutlet weak var userImage: UIImageView!
    
    let cellIdentifier = "SideMenuTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.clear.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        userImage.isUserInteractionEnabled = true
        userImage.contentMode = .scaleAspectFit
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // can increase this to increase subsections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuViews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        
        let viewTitle = sideMenuViews[indexPath.row]

        // Table view cells are reused and should be dequeued using a cell identifier.
        
        cell?.viewLabel.text = viewTitle
        
        //cell?.backgroundColor = UIColor(white: 1, alpha: 0.25)
        cell?.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell!
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        // self.performSegue(withIdentifier: "yourIdentifier", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
