//
//  SentTableViewController.swift
//  Radar
//
//  Created by student on 11/28/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SentTableViewController: UITableViewController {
    
    var messages : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Sent"
        
        // Load Messages
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoreMessage")
        do {
            messages = try managedContext.fetch(fetchRequest)
            messages = messages.filter { ($0.value(forKey: "sender") as! Bool == true) }
        }
        catch {
            print("NOPE")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Sent"
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoreMessage")
        do {
            messages = try managedContext.fetch(fetchRequest)
            messages = messages.filter { ($0.value(forKey: "sender") as! Bool == true) }
        }
        catch  {
            print("NOPE")
        }
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row].value(forKey: "message") as! Message
        cell.contentLabel.text = message.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: message.date)
        let findButton = cell.findButton
        findButton?.tag = indexPath.row
        findButton?.addTarget(self, action: #selector(findAction), for: .touchUpInside)
        
 //       let barViewControllers = self.tabBarController?.viewControllers
 //       let mapViewController = barViewControllers![0].childViewControllers[0] as! MapViewController
 
        cell.showLocation(message: message)
        return cell
    }
    
    @objc func findAction(sender: UIButton!) {
        let location = (messages[sender.tag].value(forKey: "message") as! Message).location
        
        let barViewControllers = self.tabBarController?.viewControllers
        let mapViewController = barViewControllers![0].childViewControllers[0] as! MapViewController
        let mapView = mapViewController.mapView
        
        let long = location.longitude
        let lat = location.latitude
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView?.setRegion(viewRegion, animated: false)
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers![0]
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
