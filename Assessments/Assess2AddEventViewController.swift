//
//  Assess2AddEventViewController.swift
//  Assessments
//
//  Created by ZONG-YING Tsai on 2017/7/27.
//  Copyright © 2017年 com.ppAkcotSomeD. All rights reserved.
//

import UIKit
import Firebase

class Assess2AddEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //  MARK: - UI outlets
    @IBOutlet weak var nameTextField: UITextField!{ didSet{ nameTextField.delegate = self } }
    @IBOutlet weak var priceTextField: UITextField!{ didSet{ priceTextField.delegate = self } }
    @IBOutlet weak var addressTextField: UITextField!{ didSet{ addressTextField.delegate = self } }
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            updatePicker()
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func addPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func save(_ sender: UIBarButtonItem) {
        if self.activityIndicator.isAnimating{
            //  avoid repeat submitting
            return
        }
        
        activityIndicator.startAnimating()
        var imageStr = ""
        if let eventImage = self.eventImageView.image{
            //  Here - should consider image size, but for demo, I just ignore it.
            let imageData: Data = UIImageJPEGRepresentation(eventImage, 0)!
            imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        }
        let newEvent = Event(name: self.nameTextField.text!, address: self.addressTextField.text!, price: Int(self.priceTextField.text!)!, time: self.timeLabel.text!, image: imageStr)
        
        if uid != nil{
            //  update event
            //  should check which properties should be update to server, for demo, just ignore it
            var updateItems = newEvent.toAnyObject()
            updateItems.removeValue(forKey: Assessments2.firebastSortBy)
            self.rootRef.child(Assessments2.firebaseChildName).child(self.uid!).updateChildValues(updateItems, withCompletionBlock: {_,_ in
                let alert = UIAlertController(title: "Submitting", message: "Successd", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    [unowned self] _ in
                    self.performSegue(withIdentifier: "unwindFromNewEvent", sender: self)
                })
                alert.addAction(OKAction)
                self.activityIndicator.stopAnimating()
                self.present(alert, animated: true, completion: nil)
            })
        }else{
            //  add new event
            let uniqueID = self.getUniqueID()
            
            //  communicate with Firebase - authentication
            let tmpRef = self.rootRef.child(Assessments2.firebaseChildName).child(uniqueID)
            tmpRef.setValue(newEvent.toAnyObject(), withCompletionBlock: {_,_ in
                let alert = UIAlertController(title: "Submitting", message: "Successd", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    [unowned self] _ in
                    self.performSegue(withIdentifier: "unwindFromNewEvent", sender: self)
                })
                alert.addAction(OKAction)
                self.activityIndicator.stopAnimating()
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    //  MARK: - local parameters
    fileprivate var imagePicker = UIImagePickerController()
    let formatter = DateFormatter()
    fileprivate var rootRef:DatabaseReference!{ get{ return Database.database().reference() } }
    var event: Event?{
        didSet{
            updateUI()
        }
    }
    var uid: String?    //  for update firebase
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"   //  2017-7-28 14:30
        if self.event == nil{
            //  add event
            initilizePicker()
        }else{
            //  show event
            updateUI()
        }
        updatePicker()
        updateStatus()
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
    
    //  MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if self.presentingViewController is UITabBarController{
            //  add event
            dismiss(animated: true, completion: nil)
        }else if let currentNavigationController = self.navigationController{
            //  show event
            currentNavigationController.popViewController(animated: true)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    //  MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        self.eventImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    //  MARK: - Others
    private func getUniqueID() -> String{
        let currentTime = Date().description
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        return "\(currentTime)-\(deviceID)"
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        timeLabel.text = formatter.string(from: datePicker.date)
    }
    
    private func updateUI(){
        navigationItem.title = "Event"
        
        //  for show event
        nameTextField?.text = event?.name
        priceTextField?.text = String(event?.price ?? 0)
        addressTextField?.text = event?.address
        
        if let event = self.event{
            datePicker?.date = formatter.date(from: (event.time))!
            timeLabel?.text = event.time
        }
        
        if let imageStr = event?.image, !imageStr.isEmpty, self.eventImageView != nil{
            //let image =  resizeImage(UIImage(data: Data(base64Encoded: (imageStr), options: .ignoreUnknownCharacters)!)!, boxSize: (self.image.frame.size), mode: ViewScaleMode.aspectToFit)
            self.eventImageView.image = UIImage(data: Data(base64Encoded: (imageStr), options: .ignoreUnknownCharacters)!)
        }
    }
    
    private func initilizePicker(){
        //  for add event
        datePicker.date = Date()
        timeLabel?.text = formatter.string(from: datePicker.date)
    }
    
    private func updatePicker(){
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: datePicker.date)
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: datePicker.date)
        datePicker.addTarget(self, action: #selector(Assess2AddEventViewController.datePickerChanged),for: .valueChanged)
    }
    
    private func updateStatus(){
        let name = nameTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let address = addressTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !price.isEmpty && !address.isEmpty
    }
}
