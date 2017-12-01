//
//  TabBarViewController.swift
//  Radar
//
//  Created by student on 12/1/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.init(displayP3Red: 0.498, green: 0, blue: 0, alpha: 1)

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
