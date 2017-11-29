//
//  SavedViewController.swift
//  Radar
//
//  Created by student on 11/21/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "sentViewController")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "bookmarkViewController")
        return secondChildTabVC
    }()
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue:
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue:
            vc = secondChildTabVC
        default:
            return nil
        }
        return vc
    }
    
    func displayCurrentTab(_ tabIndex: Int) {
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
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
