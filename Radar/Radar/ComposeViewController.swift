//
//  ComposeViewController.swift
//  Radar
//
//  Created by student on 11/17/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class ComposeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var filterPicker: UIPickerView!
    var rotationAngle: CGFloat!
    
    @IBOutlet weak var messageDistanceLabel: UILabel!
    @IBOutlet weak var messageDurationLabel: UILabel!
    
    @IBOutlet weak var messageDistanceStepperCheck: UIStepper!
    @IBAction func messageDistanceStepper(_ sender: UIStepper) {
        messageDistanceLabel.text = String(describing: sender.value)
    }
    
    @IBOutlet weak var messageDurationStepperCheck: UIStepper!
    @IBAction func messageDurationStepper(_ sender: UIStepper) {
        messageDurationLabel.text = String(describing: sender.value)
    }
    
    @IBAction func messageSendButton(_ sender: UIBarButtonItem) {
        if(messageTextField.text == "" || messageTextField.text == "Enter your Message (max. 160 characters)") {
            let alert = UIAlertController(title: "Oops! Out of words?", message: "You cannot send messages without content!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let barViewControllers = self.tabBarController?.viewControllers
        let mapViewController = barViewControllers![0].childViewControllers[0] as! MapViewController
        let row = filterPicker.selectedRow(inComponent: 0)
        let filter = Filter.filterValues[row]
        
        
        fire_post(postcontent: messageTextField.text ,duration: messageDurationStepperCheck.value, distance:messageDistanceStepperCheck.value , date: Date().description, filter: filter.rawValue, latitude: (mapViewController.locationManager.location?.coordinate)!.latitude, longitude: (mapViewController.locationManager.location?.coordinate)!.longitude)
        
        let message = Message(content: messageTextField.text, duration: messageDurationStepperCheck.value, distance: messageDistanceStepperCheck.value, date: Date(), filter: filter, location: (mapViewController.locationManager.location?.coordinate)!)
        let messageAnnotation = MessageAnnotation(message: message)
        mapViewController.mapView.addAnnotation(messageAnnotation)
        
        // Store Message in CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let messageTest = NSEntityDescription.insertNewObject(forEntityName: "StoreMessage", into: context)
        messageTest.setValue(message, forKey: "message")
        messageTest.setValue(true, forKey: "sender")

        do {
            try context.save()
        }
        catch {
            print("Nup")
        }
        
        // Reset Fields
        messageTextField.text = nil
        messageDurationStepperCheck.value = 1.0
        messageDistanceStepperCheck.value = 1.0
        
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers![0]
        
    }
    
    func fire_post(postcontent:String!, duration: Double!, distance: Double!, date: String!, filter: String!, latitude: Double!, longitude: Double!){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let parentRef = ref?.child("Messages").childByAutoId()
        
        parentRef?.child("Content").setValue(postcontent)
        parentRef?.child("Duration").setValue(duration)
        parentRef?.child("Distance").setValue(distance)
        parentRef?.child("Date").setValue(date)
        parentRef?.child("Filter").setValue(filter)
        parentRef?.child("Latitiude").setValue(latitude)
        parentRef?.child("Longitude").setValue(longitude)
    }
    
    
    @IBOutlet weak var messageTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Compose"
        
        // Initialize Message TextView
        messageTextField.delegate = self
        messageTextField.text = "Enter your Message (max. 160 characters)"
        messageTextField.textColor = UIColor.lightGray
        
        // Initialize and rotate FilterPicker
        rotationAngle = 90 * (.pi/180)
        filterPicker.delegate = self
        let y = filterPicker.frame.origin.y
        filterPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        filterPicker.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
        filterPicker.selectRow(2, inComponent: 0, animated: true)
        
        // Prepopulate Labels
        messageDistanceLabel.text = String(messageDistanceStepperCheck.value)
        messageDurationLabel.text = String(messageDurationStepperCheck.value)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Prepopulate Labels
        messageDistanceLabel.text = String(messageDistanceStepperCheck.value)
        messageDurationLabel.text = String(messageDurationStepperCheck.value)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        moveTextField(textView: textView, moveDistance: -250, up: true)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your Message (max. 160 characters)"
            textView.textColor = UIColor.lightGray
        }
        moveTextField(textView: textView, moveDistance: -250, up: false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 160
    }
    
    func moveTextField(textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var rowView = UIView(frame: CGRect(x: 0, y:0, width: CGFloat(100), height: CGFloat(100)))
        var imageView = UIImageView(frame: CGRect(x: 25, y:25, width: CGFloat(50), height: CGFloat(50)))
        let rowLabel = UILabel(frame: CGRect(x: 0, y: 78, width: CGFloat(100), height: 15))
        rowLabel.text = Filter.allValues[row]
        imageView.image = UIImage(named: Filter.imageValues[row])
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        rowLabel.textAlignment = .center
        rowView.addSubview(rowLabel)
        rowView.addSubview(imageView)
        rowView.transform = CGAffineTransform(rotationAngle: (-90) * (.pi/180))
        return rowView
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Filter.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Filter.allValues[row]
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
