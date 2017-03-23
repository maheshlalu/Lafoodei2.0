//
//  LFCommentViewViewController.swift
//  Lefoodie
//
//  Created by Manishi on 2/23/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RSKKeyboardAnimationObserver
import RealmSwift

class LFCommentViewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var growingTextView: RSKGrowingTextView!
    private var isVisibleKeyboard = true
    @IBOutlet weak var commentsTblView: UITableView!
    
    var feedData:LFFeedsData!
    var userDetails:LFMyProfile!
    var myProfile : LFMyProfile!
    var commentsDict:NSDictionary!
    var commentsArr: NSMutableArray = NSMutableArray()
    
    var reloadSection : (_ isReload:Bool) -> Void = {responce in print()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        self.commentsTblView.tableFooterView = UIView()
        self.title = "Comments"
        let nib = UINib(nibName: "LFCommentTableViewCell", bundle: nil)
        self.commentsTblView.register(nib, forCellReuseIdentifier: "LFCommentTableViewCell")
        
        self.commentsTblView.estimatedRowHeight = 70
        self.commentsTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    func updateTheCommentCountInFeed(count:Int){
        
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "feedID=%@", feedData.feedID)
        let userData = realm.objects(LFHomeFeeds.self).filter(predicate).first
        try! realm.write {
            userData?.feedCommentsCount = String(count)
        }
    }
    
    func getComments(){
        
        LFDataManager.sharedInstance.getComments(feedId: feedData.feedID) { (responseDict) in
            let response:NSArray = responseDict.value(forKey: "jobs") as! NSArray
            self.commentsDict = response[0] as! NSDictionary
            self.commentsArr.removeAllObjects()
            let commentsArr = self.commentsDict.value(forKey: "jobComments") as! NSArray
            self.commentsArr.addObjects(from:commentsArr.reverseObjectEnumerator().allObjects)
            self.commentsTblView.reloadData()
            self.updateTheCommentCountInFeed(count: self.commentsArr.count)
            if self.commentsArr.count == 0{
                self.commentsTblView.separatorStyle = .none
                self.commentLbl.isHidden = false
                self.commentLbl.textColor = UIColor.appTheamColor()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.growingTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.reloadSection(true)
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
    
    
    func dateFormateConvertion(date:String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "HH:mm MMM d',' yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        print(resultString)
        
        return resultString
    }
    
    //Tableview Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return commentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFCommentTableViewCell", for: indexPath) as? LFCommentTableViewCell
        if commentsArr.count != 0{
            let data = commentsArr[indexPath.row] as! NSDictionary
            print(data)
            let userNameTxt = data.value(forKey: "postedBy_Name") as? String
            let commentTxt = data.value(forKey: "comment") as? String
            
            let attributedString = NSMutableAttributedString()
            let attributedString1 = NSMutableAttributedString(string:" \(commentTxt!)")
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12)]
            let boldString = NSMutableAttributedString(string:userNameTxt!, attributes:attrs)
            attributedString.append(boldString)
            attributedString.append(attributedString1)
            
            cell?.commentTxt.attributedText = attributedString
            
            let date = data.value(forKey: "time") as! String
            cell?.commentTime.text = date.timeAgoSinceDate(numericDates: true)
            let img = data.value(forKey: "logo") as! String
            cell?.commentImg.setImageWith(NSURL(string:img ) as URL!, usingActivityIndicatorStyle: .white)
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        
        let arr = commentsArr[indexPath.row] as! NSDictionary
        
        if (arr.value(forKey: "postedBy_Id") as! String) == (myProfile.Mac_userId){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            self.commentsTblView.beginUpdates()
            let arr = commentsArr[indexPath.row] as! NSDictionary
            let commentId = arr.value(forKey: "commentId")
            LFDataManager.sharedInstance.deleteComment(commentId: commentId as! String, completion: { (isSuccess) in
                self.commentsArr.removeObject(at: indexPath.row)
                self.commentsTblView.deleteRows(at: [indexPath], with: .fade)
            })
            self.commentsTblView.endUpdates()
        }
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        let trimmedString = self.growingTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString != ""{
            let realm = try! Realm()
            self.userDetails = realm.objects(LFMyProfile.self).first
            
            LFDataManager.sharedInstance.postComment(jobId: feedData.feedID, comment: trimmedString, macId: userDetails.userItemCode) { (responseDict) in
                let status = responseDict.value(forKey: "status") as! String
                if status == "1"{
                    self.commentLbl.isHidden = true
                    self.getComments()
                    self.commentsTblView.reloadData()
                    self.growingTextView.text = nil
                    self.growingTextView.resignFirstResponder()
                }
            }
        }
    }
}

