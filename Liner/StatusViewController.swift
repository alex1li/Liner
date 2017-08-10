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
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
    var tableView: UITableView!
    var handle: DatabaseHandle?
    var handle2: DatabaseHandle?
    var ref: DatabaseReference?
    var count: Int!
    var found: Bool!
    
    var myList:[String] = []

    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        ref = Database.database().reference()

        
        label.center = CGPoint(x: 200, y: 300)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "You are not in a Queue"
        
        let user = Auth.auth().currentUser
        if(user?.displayName != nil){
            label.text =  "You are in queue: " + (user?.displayName)!
            
            //self.count = -1;
            self.found = false

            handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                    
                    
                    if(item == user?.email) {
                        self.label.text = "You are in queue " + (user?.displayName!)! + " with place: " + String(self.myList.count-1)
                        self.found = true
                    }

                    if (!self.found){
                        self.myList.append(item)
                    }
                    
                    

                    //self.count = self.count + 1;
                
                    
                    
                }
            })
            
            handle2 = ref?.child("Queues").child((user?.displayName!)!).observe(.childRemoved, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                    
                    
                        if let index = self.myList.index(of: item) {
                        self.myList.remove(at:index)
                            self.label.text = "You are in queue " + (user?.displayName!)! + " with place: " + String(self.myList.count-1)
                            print(self.myList)

                    
                        }
                        
                    
                    
                    //self.count = self.count + 1;
                    
                    
                    
                }
            })

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
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        ref = Database.database().reference()

        let user = Auth.auth().currentUser
        
        self.count = -1;
        self.found = false


        if(user?.displayName != nil)
        
        {
        
        handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if let item = snapshot.value as! String? {
                
                if (!self.found){
                    self.myList.append(item)
                }
                
                
                if(item == user?.email) {
                    self.label.text = "You are in queue " + (user?.displayName!)! + " with place: " + String(self.myList.count-1)
                    self.found = true
                }
                
                
                //self.count = self.count + 1;
                
                
                
            }
        })
      

        }
    
    
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
