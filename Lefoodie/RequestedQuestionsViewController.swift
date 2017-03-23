//
//  RequestedQuestionsViewController.swift
//  FitSport
//
//  Created by Manishi on 11/30/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit
import RealmSwift

struct userQuestions {
    let id:String
    let question:String
    let answer:String
    let fromDict:NSDictionary
    let toDict:NSDictionary
}

class RequestedQuestionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var faqCollectionView: UICollectionView!
    var userQuestionsArr = [userQuestions]()
    var requestedQuestionsArr = [userQuestions]()
    var isRequestedQuestions:Bool = Bool()
    var myProfile : LFMyProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.faqCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.faqCollectionView.reloadData()
        let nib = UINib(nibName: "QuestionChatCollectionViewCell", bundle: nil)
        self.faqCollectionView.register(nib, forCellWithReuseIdentifier: "QuestionChatCollectionViewCell")
        self.faqCollectionView.contentSize = CGSize(width: 320, height: 94)
        
        let realm = try! Realm()
        self.myProfile = realm.objects(LFMyProfile.self).first
        
        getPostedQuestions()
        
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return userQuestionsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionChatCollectionViewCell", for: indexPath)as? QuestionChatCollectionViewCell
        cell?.questionTxtView.adjustsFontForContentSizeCategory = true
        cell?.answerTxtView.adjustsFontForContentSizeCategory = true
        cell?.layer.cornerRadius = 4
        
        let questions: userQuestions =  (self.userQuestionsArr[indexPath.item] as? userQuestions)!
        
        cell?.questionTxtView.text = questions.question
        let answerStr = questions.answer
        if answerStr == ""{
            cell?.answerPic.isHidden = true
        }else{
            cell?.answerTxtView.text = questions.answer
            if (questions.toDict.value(forKey: "userImagePath") as! String != ""){
                let url = NSURL(string: questions.toDict.value(forKey: "userImagePath") as! String)
                cell?.answerPic.setImageWith(url as URL!, usingActivityIndicatorStyle: .gray)
            }
        }
        
        if (questions.fromDict.value(forKey: "userImagePath") as! String != ""){
            let url = NSURL(string: questions.fromDict.value(forKey: "userImagePath") as! String)
            cell?.QuestionPic.setImageWith(url as URL!, usingActivityIndicatorStyle: .gray)
        }
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/1-9,height: 94)
        
    }
    
    func getPostedQuestions(){
        var userEmail:String = String()
        userEmail = myProfile.userEmail

        LFDataManager.sharedInstance.getPosterQuestions(ownerId:CXAppConfig.sharedInstance.getAppMallID(), email:userEmail) { (responseDict) in
            
            let keys : NSArray = responseDict.allKeys as NSArray
            if keys.contains("questions") {
                let arr = responseDict["questions"] as! [[String:AnyObject]]
                for gallaeryData in arr {
                    let picDic : NSDictionary =  gallaeryData as NSDictionary
                    let locationStruct : userQuestions = userQuestions(id: CXAppConfig.resultString(input: picDic.value(forKey:"id")! as AnyObject), question: picDic.value(forKey: "question") as! String, answer: picDic.value(forKey: "answer") as! String, fromDict: picDic.value(forKey: "from") as! NSDictionary, toDict: picDic.value(forKey: "to") as! NSDictionary)
                    
                    self.userQuestionsArr.append(locationStruct)
                    self.faqCollectionView.reloadData()
                }
            }
        }
    }
}

