//
//  LFFoodDetailViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 05/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFoodDetailViewController: UIViewController {

 
   
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var reservationBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonColors()
        
   

        // Do any additional setup after loading the view.
    }
    
    func buttonColors()
    {
        
        self.directionBtn.layer.borderColor = UIColor.appTheamColor().cgColor
        self.directionBtn.setTitleColor(UIColor.appTheamColor(), for: .normal)
        
        self.followBtn.layer.borderColor = UIColor.appTheamColor().cgColor
        self.followBtn.setTitleColor(UIColor.appTheamColor(), for: .normal)
        
        self.reservationBtn.layer.borderColor = UIColor.appTheamColor().cgColor
        self.reservationBtn.setTitleColor(UIColor.appTheamColor(), for: .normal)
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
