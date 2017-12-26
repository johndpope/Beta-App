//
//  ProboRequirementsViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/26/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import WebKit

class ProboRequirementsViewController: UIViewController {

    @IBOutlet weak var webKitView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url: URL = URL(string: "https://github.com/jamesjweber/Beta-App/blob/master/Documentation/Probo%20Requirements.md#probo-rules-and-requirements")!
        let request = URLRequest(url: url)
        
        webKitView.load(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
