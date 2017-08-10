//
//  StatusViewController.swift
//  Liner
//
//  Created by Alexander Li on 8/7/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StatusViewController: UIViewController {
    
    //MARK: Components
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        label.center = CGPoint(x: 200, y: 300)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "You are not in a Queue"
        
        let user = Auth.auth().currentUser
        if(user?.displayName != nil){
            label.text =  "You are in queue: " + (user?.displayName)!
        }
        
        self.view.addSubview(label)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinQueue))
        
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func joinQueue(_ button:UIBarButtonItem!){
        self.navigationController?.pushViewController( ChooseViewController(), animated: true)
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
