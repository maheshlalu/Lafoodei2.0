//
//  LFFlagReportViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFlagReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nameArray = ["","Negative/Offensive/Inappropriate Post","Poor Image Quality",]

    @IBOutlet weak var flagReportTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.tableFooterView = [UIView new];
        self.flagReportTableView.tableFooterView = UIView()

        
        let nib = UINib(nibName: "LFFlagReportTableViewCell", bundle: nil)
        self.flagReportTableView.register(nib, forCellReuseIdentifier: "LFFlagReportTableViewCell")

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "LFFlagReportTableViewCell", for: indexPath)as? LFFlagReportTableViewCell
        
        if indexPath.row == 0
        {
            
            cell?.reasonLabel.isHidden = false
            cell?.postLabel.isHidden = true
            cell?.reportingBtn.isHidden = true
            
        }
        else if indexPath.row == 1
        {
            cell?.reasonLabel.isHidden = true
            cell?.postLabel.isHidden = false
            cell?.reportingBtn.isHidden = false
        }
        else if indexPath.row == 2
        {
            cell?.reasonLabel.isHidden = true
            cell?.postLabel.isHidden = false
            cell?.reportingBtn.isHidden = false
        }
        cell?.selectionStyle = .none
        cell?.postLabel.text = nameArray[indexPath.row]
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPostViewController")as? LFPostViewController
       self.present(storyboard!, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

}
