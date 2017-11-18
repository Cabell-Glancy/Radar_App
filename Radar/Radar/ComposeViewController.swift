//
//  ComposeViewController.swift
//  Radar
//
//  Created by student on 11/17/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var filterPicker: UIPickerView!
    var rotationAngle: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Compose"
        rotationAngle = 90 * (.pi/180)
        
        filterPicker.delegate = self
        let y = filterPicker.frame.origin.y
        filterPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        filterPicker.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
        filterPicker.selectRow(2, inComponent: 0, animated: true)
        
        // Do any additional setup after loading the view.
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
