//
//  LFCommentViewViewController.swift
//  Lefoodie
//
//  Created by Manishi on 2/23/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RSKKeyboardAnimationObserver

class LFCommentViewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: RSKGrowingTextView!
    private var isVisibleKeyboard = true
    @IBOutlet weak var commentsTblView: UITableView!
    
     var nameArray = ["Alexandra added a photo to Best Cocktails Ever! list.","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list Alexandra added a photo to Best Cocktails Ever! list Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! list","Alexandra added a photo to Best Cocktails Ever! listAlexandra added a photo to Best Cocktails Ever! listAlexandra added a photo to Best Cocktails Ever! list"]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        //setUpNavigationBar()
        self.title = "Comments"
        let nib = UINib(nibName: "LFCommentTableViewCell", bundle: nil)
        self.commentsTblView.register(nib, forCellReuseIdentifier: "LFCommentTableViewCell")
        
        self.commentsTblView.estimatedRowHeight = 66
        self.commentsTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.unregisterForKeyboardNotifications()
    }
    
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height+8
        let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight : 8;
        self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = keyboardYPosition
        self.view.layoutIfNeeded()
    }
    
    @IBAction func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.growingTextView.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
        }
        )
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        self.unregisterForKeyboardNotifications()
    }
    
    //Tableview Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFCommentTableViewCell", for: indexPath) as? LFCommentTableViewCell
        cell?.commentTxt.text = nameArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


/*{
 
 func notificationServiceCall()
 {
 CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "keys" as AnyObject,"mallId" : CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
 print(responseDict)
 self.notificationData = responseDict.value(forKey: "jobs") as! NSArray
 }
 }
 
 }*/
