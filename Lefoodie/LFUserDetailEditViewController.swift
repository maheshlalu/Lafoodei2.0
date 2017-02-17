//
//  LFUserDetailEditViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import GoogleSignIn
import RealmSwift

class LFUserDetailEditViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var userDpImaView: UIImageView!
    @IBOutlet weak var bannerImgView: UIImageView!
    @IBOutlet weak var dpLayer: UIView!
    @IBOutlet weak var BannerLayer: UIView!
    @IBOutlet weak var editTableView: UITableView!
    var moveValue: CGFloat!
    var moved: Bool = false
    var activeTextField = UITextField()
    var nameArray = ["First Name","Last Name","Birth Day(Optional)","E-Mail","Phone Number(Optional)"]
    var myProfile : LFMyProfile!
    let realm = try! Realm()
    var resultDate:String = String()
    var isDP:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserDetailEditViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFUserDetailEditViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        let bannerLayerTap = UITapGestureRecognizer(target: self, action: #selector(handleTapForBanner(sender:)))
        self.BannerLayer.addGestureRecognizer(bannerLayerTap)
        
        let dpLayerTap = UITapGestureRecognizer(target: self, action: #selector(handleTapForDp(sender:)))
        self.dpLayer.addGestureRecognizer(dpLayerTap)
        
        let nib = UINib(nibName: "LFEditTableViewCell", bundle: nil)
        self.editTableView.register(nib, forCellReuseIdentifier: "LFEditTableViewCell")
        buttoncreated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
    }
    
    func setImages(){
        self.myProfile = realm.objects(LFMyProfile.self).first
        print(self.myProfile)
        
        self.userDpImaView.setImageWith(NSURL(string: self.myProfile.userPic) as URL!, usingActivityIndicatorStyle: .white)
       // self.bannerImgView.setImageWith(NSURL(string: self.myProfile.userPic) as URL!, usingActivityIndicatorStyle: .white)
    
    }
    //Button Created
    func buttoncreated(){
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 8, width: 40, height: 40)
        button.setTitle("Edit", for: .normal)
        button.setTitle("Save", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = button
        self.navigationItem.setRightBarButton(item1, animated: true)
    }
    
    //MARK: Button Action
    func buttonAction(_ sender:UIButton){
        
        if(sender.titleLabel?.text == "Edit")
        {
            sender.isSelected = !sender.isSelected
            sender.setImage(UIImage(named:"item1"), for: UIControlState.normal)
            
            //enabling layers
            self.dpLayer.isHidden = false
            self.BannerLayer.isHidden = false
            
            //enabling textfields
            var cell = LFEditTableViewCell()
            for i in 0...4{
                
                let indexPath : NSIndexPath = NSIndexPath(row:i, section: 0)
                cell = self.editTableView.cellForRow(at: indexPath as IndexPath) as! LFEditTableViewCell
                cell.infoTextfield.isUserInteractionEnabled = true
                if cell.infoTextfield.tag == 500{
                    cell.infoTextfield.isUserInteractionEnabled = false
                }
            }
 
        }else if sender.titleLabel?.text == "Save" {
            sender.isSelected = !sender.isSelected
            
            //sumbitDetails
        }
    }
    // Pls edit the stuff
    /*    func sumbitDetails(){
     LoadingView.show(true)
     let number : NSNumber = NSUserDefaults.standardUserDefaults().valueForKey("MACID_JOBID") as! NSNumber
     let jobId : String = number.stringValue
     
     let firstName = self.fristNameTxtField.text
     let lastName = self.lastNameTxtField.text
     let fullName = "\(firstName!) \(lastName!)"
     let Email = self.emailTxtField.text
     let state = self.stateTxtField.text
     let city = self.cityTxtField.text
     let address = self.addressTxtField.text
     let mobileNo = self.moblieTxtField.text
     let country = self.countryTxtField.text
     
     
     let jsonDic : NSMutableDictionary = NSMutableDictionary()
     jsonDic.setObject(firstName!, forKey: "firstName" as NSCopying)
     jsonDic.setObject(lastName!, forKey: "lastName" as NSCopying)
     jsonDic.setObject(Email!, forKey: "Email" as NSCopying)
     jsonDic.setObject(mobileNo!, forKey: "mobileNo" as NSCopying)
     jsonDic.setObject(address!, forKey: "address" as NSCopying)
     jsonDic.setObject(city!, forKey: "city" as NSCopying)
     jsonDic.setObject(state!, forKey: "state" as NSCopying)
     jsonDic.setObject(country!, forKey: "country" as NSCopying)
     jsonDic.setObject(fullName, forKey: "FullName" as NSCopying)
     
     print(jsonDic)
     
     self.activeTheUser(jsonDic, jobId: jobId)
     LoadingView.hide()
     self.submitDetails = true
     
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFEditTableViewCell", for: indexPath)as? LFEditTableViewCell
        
        cell?.nameLabel.text = nameArray[indexPath.row]
        cell?.infoTextfield.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell?.stackView.addGestureRecognizer(tap)
        tableView.allowsSelection = false
        self.myProfile = realm.objects(LFMyProfile.self).first
        print(self.myProfile)
        
        cell?.selectionStyle = .none

        
        if cell?.nameLabel.text == "First Name"{
            cell?.infoTextfield.tag = 100
            cell?.infoTextfield.text = self.myProfile.userFirstName
        }else if cell?.nameLabel.text == "Last Name"{
            cell?.infoTextfield.tag = 200
            cell?.infoTextfield.text = self.myProfile.userLastName
        }else if cell?.nameLabel.text == "Birth Day(Optional)"{
            cell?.infoTextfield.tag = 300
            //cell?.infoTextfield.text = self.myProfile.userFirstName
        }else if cell?.nameLabel.text == "E-Mail"{
            cell?.infoTextfield.tag = 500
            cell?.infoTextfield.text = self.myProfile.userEmail
        }else if cell?.nameLabel.text == "Phone Number(Optional)"{
            cell?.infoTextfield.tag = 600
            cell?.infoTextfield.keyboardType = .phonePad
            cell?.infoTextfield.text = self.myProfile.userMobileNumber
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func handleTapForBanner(sender:UITapGestureRecognizer? = nil) {
        imagePickerAction()
        
//        let alert = UIAlertController(title: "Alert", message: "Are You Sure?", preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Okay", style: .default) { (alert: UIAlertAction!) -> Void in
//            
//            
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
//            
//        }
//        alert.addAction(defaultAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion:nil)
        
    }
    
    func handleTapForDp(sender: UITapGestureRecognizer? = nil) {
        isDP = true
        imagePickerAction()
        
    }
    
    func imagePickerAction(){
        
        //Create the AlertController and add Its action like button in Actionsheet
        let choosePhotosActionSheet: UIAlertController = UIAlertController(title: "Select An Option", message: nil , preferredStyle: .actionSheet)
        
        let chooseFromPhotos: UIAlertAction = UIAlertAction(title: "Choose From Photos", style: .default)
        { action -> Void in
            print("choose from photos")
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(chooseFromPhotos)
        
        let capturePicture: UIAlertAction = UIAlertAction(title: "Capture Image", style: .default)
        { action -> Void in
            print("camera shot")
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(capturePicture)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        { action -> Void in
            print("Delete")
        }
        choosePhotosActionSheet.addAction(cancel)
        
        self.present(choosePhotosActionSheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isDP{
                userDpImaView.contentMode = .scaleToFill
                userDpImaView.image = pickedImage
                self.dpLayer.isHidden = true
            }else{
                bannerImgView.contentMode = .scaleToFill
                bannerImgView.image = pickedImage
                self.BannerLayer.isHidden = true
            }
            
            let image = pickedImage as UIImage
            let imageData = NSData(data: UIImagePNGRepresentation(image)!)
            UserDefaults.standard.set(imageData, forKey: "IMG_DATA")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: Keyboard willshow and Will hide Methods
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-130)
            }
            else {
                
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 65
            }
            else {
                
            }
        }
        
    }
    //MARK: Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 600{
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool
        }else{ return true }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 300{
            datePicker(textField)
        }
    }
    
    func datePicker(_ textField: UITextField){
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.appTheamColor()
        toolBar.sizeToFit()
        
        let currentDate: NSDate = NSDate()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components: NSDateComponents = NSDateComponents()
        
        components.year = -100
        components.month = -12
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.year = 0
        components.month = 0
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        datePickerView.minimumDate = minDate as Date
        datePickerView.maximumDate = maxDate as Date
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(LFUserDetailEditViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let  resultDate = dateFormatter.string(from: sender.date)
        
        var cell = LFEditTableViewCell()
        let indexPath : NSIndexPath = NSIndexPath(row:2, section: 0)
        cell = self.editTableView.cellForRow(at: indexPath as IndexPath) as! LFEditTableViewCell
        cell.infoTextfield.text = resultDate
    }
    
    func donePicker (sender:UIBarButtonItem)
    {
        self.view.endEditing(true)
    }
    
    // Custom Alert View
    func showAlert(message:String, status:Int){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .default) { (alert: UIAlertAction!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
          
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion:nil)
    }
    
    //Update multiple properties
    
    func activeTheUser(parameterDic:NSDictionary,jobId:String){
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameterDic, options: .prettyPrinted) as NSData
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
        
        let jsonStringFormat = String(data:(jsonData as NSData) as Data, encoding: String.Encoding.utf8)
        print(jsonStringFormat!)
        
       /* LFDataManager.sharedInstance.getUpdateMultipleProperties(jobId: <#T##String#>, jsonString: <#T##String#>) { (responseDict) in
                print(responseDict)
                let message = responseDict.value(forKey: "message") as! String
                let status = Int(responseDict.value(forKey: "status") as! String)
                self.showAlert(message: message, status: status!)
        }*/
    }
    
    //Image Upload
    
    func imageUpload(){
        let imgData = UserDefaults.standard.value(forKey: "IMG_DATA")
        LFDataManager.sharedInstance.imageUpload(imageData: imgData as! Data) { (responseDict) in
            print(responseDict)
            let status: Int = Int(responseDict.value(forKey: "status") as! String)!
            
            if status == 1{
                // Pls save mac job id below
                //let number : NSNumber = NSUserDefaults.standardUserDefaults().valueForKey("MACID_JOBID") as! NSNumber
                //let jobId : String = number.stringValue
                let imgUrl = responseDict.value(forKey: "filePath") as! String
                let jsonDic : NSMutableDictionary = NSMutableDictionary()
                jsonDic.setObject(imgUrl, forKey: "Image" as NSCopying)
                print(jsonDic)
                //self.activeTheUser(jsonDic, jobId: jobId)
            }
        }
    }
}

/*@IBAction func actionSheetButtonPressed(sender: UIButton) {
 let alert = UIAlertController(title: "My Alert", message: "This is an action sheet.", preferredStyle: .Alert) // 1
 let firstAction = UIAlertAction(title: "one", style: .Default) { (alert: UIAlertAction!) -> Void in
 NSLog("You pressed button one")
 } // 2
 
 let secondAction = UIAlertAction(title: "two", style: .Default) { (alert: UIAlertAction!) -> Void in
 NSLog("You pressed button two")
 } // 3
 
 alert.addAction(firstAction) // 4
 alert.addAction(secondAction) // 5
 presentViewController(alert, animated: true, completion:nil)*/


/*  let alert = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .Alert) // 7
 let defaultAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
 NSLog("You pressed button OK")
 } // 8
 
 alert.addAction(defaultAction) // 9
 alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
 textField.placeholder = "Input data..."
 } // 10
 
 presentViewController(alert, animated: true, completion:nil)  // 11*/
