//
//  Assess1AddPlayerViewController.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/25.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit

class Assess1AddPlayerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //  MARK: - Global parameters
    let heights = Array(48...96)
    let weights = Array(80...300)
    let ages = Array(1...100)
    
    //  MARK: - Local parameters
    var heightIdx = 0
    var weightIdx = 0
    var ageIdx = 0
    
    var newPlayer: Player?
    
    //  MARK: - UI outlets
    @IBOutlet weak var name: UITextField!{ didSet{ name.delegate = self } }
    @IBOutlet weak var country: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!{
        didSet{
            pickerView.delegate = self
            updatePicker()
        }
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //  MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if self.presentingViewController is UITabBarController{
            //  add player
            dismiss(animated: true, completion: nil)
        }else if let currentNavigationController = self.navigationController{
            //  show player
            currentNavigationController.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let button = sender as? UIBarButtonItem, button == saveButton{
            newPlayer = Player(name: name.text!, country: country.selectedSegmentIndex, height: heights[heightIdx], weight: weights[weightIdx], age: ages[ageIdx])
        }
    }
    
    //  MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStatus()
    }
    
    //  MARK: - Life cycke
    override func viewDidLoad() {
        super.viewDidLoad()
        if newPlayer != nil{
            updateUI()
            //pickerView.isUserInteractionEnabled = true
        }else{
            heightIdx = heights.count/2
            weightIdx = weights.count/2
            ageIdx = ages.count/2
        }
        updatePicker()
        updateStatus()
    }
    
    //  MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (component == 0) ? heights.count : (component == 1) ? weights.count : ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (component == 0) ? customHeightString(row) :
            (component == 1) ? customWeightString(row) :
            customAgeString(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            heightIdx = row
        }else if component == 1{
            weightIdx = row
        }else{
            ageIdx = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        switch component {
        case 0:
            attributedString = NSAttributedString(string: customHeightString(row), attributes: [NSForegroundColorAttributeName : UIColor.red])
        case 1:
            attributedString = NSAttributedString(string: customWeightString(row), attributes: [NSForegroundColorAttributeName : UIColor.green])
        case 2:
            attributedString = NSAttributedString(string: customAgeString(row), attributes: [NSForegroundColorAttributeName : UIColor.blue])
        default:
            attributedString = nil
        }
        return attributedString
    }
    
    //  MARK: - Others
    private func updateUI(){
        //print (newPlayer ?? "empty")
        navigationItem.title = Assessments1.navigationItenTileForShoePlayer
        name?.text = newPlayer?.name
        heightIdx = heights.index(where: {$0 == newPlayer?.height})!
        weightIdx = weights.index(where: {$0 == newPlayer?.weight})!
        ageIdx = ages.index(where: {$0 == newPlayer?.age})!
        country.selectedSegmentIndex = (newPlayer?.country)!
    }
    
    private func updateStatus(){
        let text = name.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func updatePicker(){
        self.pickerView.selectRow(heightIdx, inComponent: 0, animated: false)
        self.pickerView.selectRow(weightIdx, inComponent: 1, animated: false)
        self.pickerView.selectRow(ageIdx, inComponent: 2, animated: false)
    }
    
    private func customHeightString(_ hidx: Int) -> String{
        return String(heights[hidx]/12) + Assessments1.heightRepresetation1 + String(heights[hidx]%12) + Assessments1.heightRepresetation2
    }
    
    private func customWeightString(_ widx: Int) -> String{
        return String(weights[widx]) + Assessments1.weightRepresetation
    }
    
    private func customAgeString(_ aidx: Int) -> String{
        return String(ages[aidx])
    }
}
