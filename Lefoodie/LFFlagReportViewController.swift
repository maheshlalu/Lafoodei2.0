//
//  LFFlagReportViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 22/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFlagReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nameArray = ["","Negative / Offensive / Inappropriate Post","Poor Image Quality",]

    @IBOutlet weak var flagReportTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttoncreated()
        
        //self.tableView.tableFooterView = [UIView new];
        self.flagReportTableView.tableFooterView = UIView()
        let nib = UINib(nibName: "LFFlagReportTableViewCell", bundle: nil)
        self.flagReportTableView.register(nib, forCellReuseIdentifier: "LFFlagReportTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Flag / Report"
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
        if indexPath.row == 1
        {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFPostViewController")as? LFPostViewController
       self.navigationController?.pushViewController(storyboard!, animated: true)
            self.title = ""
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    func buttoncreated(){
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 8, width: 60, height: 60)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = button
        self.navigationItem.setRightBarButton(item1, animated: true)
    }
    func cancelBtnAction()
    {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }

}
