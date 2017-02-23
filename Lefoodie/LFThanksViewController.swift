//
//  LFThanksViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFThanksViewController: UIViewController {
    
    @IBOutlet weak var thankLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let firstWord = "For helping to keep LeFoodie a "
        let secondWord = "Positive"
        let thirdWord = "best"
        let finaString =  NSAttributedString(string: firstWord)
        let attributedText = NSMutableAttributedString(string:firstWord)
        attributedText.append(attributedString(from: secondWord, nonBoldRange: NSMakeRange(0, secondWord.characters.count-8)))
        attributedText.append(NSAttributedString(string: " environment and a place for your "))
        attributedText.append(attributedString(from: thirdWord, nonBoldRange: NSMakeRange(0, thirdWord.characters.count-4)))
        attributedText.append(NSAttributedString(string: " foodie advantures!"))
        thankLabel.attributedText =  attributedText
        self.navigationItem.title = "Flag / Report"
        // Do any additional setup after loading the view.
    }
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        //let fontSize = UIFont.systemFontSize
        //        NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)
        
        let attrs = [
            NSFontAttributeName:UIFont.italicSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor.black
        ]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    @IBAction func backToleFoodieBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
