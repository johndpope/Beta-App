//
//  HousePositionsTableViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class HousePositionsTableViewController: UITableViewController {

    struct HousePositionSections {
        var sectionName : String!
        var sectionPositions : [String]!
    }
    
    var checked = Set<IndexPath>()
    
    var housePosArr = [HousePositionSections]()
    
    func setHousePositionSections() {
        housePosArr = [
            HousePositionSections(sectionName: "Misc. House Positions",
                             sectionPositions: ["President",
                                               "House Manager",
                                               "Kitchen Manager",
                                               "Chapter Counselor",
                                               "IFC Representative",
                                               "Technology Chair",
                                               "Wellness Chair",
                                               "Wellness Committee",
                                               "BMOC Chair",
                                               "BMOC Member"]),
            
            HousePositionSections(sectionName: "Programming",
                             sectionPositions: ["VP of Programming",
                                               "Programming Committee Member",
                                               "Social Chair",
                                               "Social Committee Member",
                                               "Philanthropy Chair",
                                               "Community Service Chair",
                                               "Intramural Chair"]),
            
            HousePositionSections(sectionName: "Brotherhood",
                                  sectionPositions: ["VP of Brotherhood",
                                                    "Brotherhood Chair",
                                                    "Brotherhood Committee Member",
                                                    "Kai Chair",
                                                    "Kai Committee",
                                                    "Scholarship Chair",
                                                    "Scholarship Committee Member",
                                                    "Ritual Chair"]),
            
            HousePositionSections(sectionName: "Education",
                                  sectionPositions: ["VP of Education",
                                                    "Education Chair",
                                                    "Education Committee Member"]),
            
            HousePositionSections(sectionName: "Recruitment",
                                  sectionPositions: ["VP of Recruitment",
                                                    "Recruitment Committee Member"]),
            
            HousePositionSections(sectionName: "Risk Management",
                                  sectionPositions: ["VP of Risk", "Risk Committee Member"]),
            
            HousePositionSections(sectionName: "Finance",
                                  sectionPositions: ["VP of Finance"]),
            
            HousePositionSections(sectionName: "Communication",
                                  sectionPositions: ["VP of Communication"]),
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setHousePositionSections()
        
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
        // #warning Incomplete implementation, return the number of sections
        return housePosArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return housePosArr[section].sectionPositions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "housePositonsTableViewCell", for: indexPath) as! HousePositionsTableViewCell
        
        cell.label.text = housePosArr[indexPath.section].sectionPositions[indexPath.row]
        
        cell.checkMark.isHidden = !self.checked.contains(indexPath)
        
        cell.backgroundColor = hexStringToUIColor(hex: "22c1fa")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return housePosArr[section].sectionName
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = hexStringToUIColor(hex: "20b1f8")
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.checked.contains(indexPath) {
            self.checked.remove(indexPath)
        } else {
            self.checked.insert(indexPath)
        }
        
        tableView.reloadRows(at:[indexPath], with:.fade)
        
        //if (tableView.cellForRow(at: indexPath)?.checkMark.hidden == true){
        //    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        //} else {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        //}
    }

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

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
