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
    var yourQueueLabel:UILabel!
    var yourLocationLabel:UILabel!
    var queueNameLabel:UILabel!
    var queueLocationLabel:UILabel!
    
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
        let user = Auth.auth().currentUser
        
        //Your Queue Label
        yourQueueLabel = UILabel()
        yourQueueLabel.frame = CGRect(x: 100, y: 50, width: 200, height: 200)
        yourQueueLabel.textAlignment = .center
        yourQueueLabel.numberOfLines=1
        yourQueueLabel.text = "Queue"
        yourQueueLabel.textColor=UIColor.black
        yourQueueLabel.font=UIFont.systemFont(ofSize: 20)
        yourQueueLabel.backgroundColor=UIColor.white
        self.view.addSubview(yourQueueLabel)
        
        //Your Location Label
        //Your Queue Label
        yourLocationLabel = UILabel()
        yourLocationLabel.frame = CGRect(x: 100, y: 300, width: 200, height: 200)
        yourLocationLabel.textAlignment = .center
        yourLocationLabel.numberOfLines=1
        yourLocationLabel.text = "Location"
        yourLocationLabel.textColor=UIColor.black
        yourLocationLabel.font=UIFont.systemFont(ofSize: 20)
        yourLocationLabel.backgroundColor=UIColor.white
        self.view.addSubview(yourLocationLabel)
        
        //Queue name Label
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 50, y: 180, width: 300, height: 100)
        queueNameLabel.textAlignment = .center
        queueNameLabel.numberOfLines=1
        queueNameLabel.font=UIFont.systemFont(ofSize: 30)
        if(user?.displayName != nil){
            queueNameLabel.text = (user?.displayName)!
            queueNameLabel.backgroundColor=UIColor.blue
            queueNameLabel.textColor=UIColor.white
        }
        else {
           queueNameLabel.text = "..."
            queueNameLabel.backgroundColor=UIColor.lightGray
            queueNameLabel.textColor=UIColor.black
        }
        self.view.addSubview(queueNameLabel)
        
        //Queue location label
        queueLocationLabel = UILabel()
        queueLocationLabel.frame = CGRect(x: 50, y: 430, width: 300, height: 100)
        queueLocationLabel.textAlignment = .center
        queueLocationLabel.numberOfLines=1
        queueLocationLabel.font=UIFont.systemFont(ofSize: 30)
        if(user?.displayName != nil){
            queueLocationLabel.textColor=UIColor.white
            queueLocationLabel.backgroundColor=UIColor.blue

            handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                    if(item == user?.email) {
                        self.queueLocationLabel.text = String(self.myList.count-1)
                        Queue.userLocationFound = true
                    }

                    if (!Queue.userLocationFound){
                        self.myList.append(item)
                    }
                }
            })
            
            handle2 = ref?.child("Queues").child((user?.displayName!)!).observe(.childRemoved, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                        if let index = self.myList.index(of: item) {
                        self.myList.remove(at:index)
                            self.queueLocationLabel.text = String(self.myList.count-1)
                            print(self.myList)

                        }

                }
            })

        }
        else{
            queueLocationLabel.text = "..."
            queueLocationLabel.textColor=UIColor.black
            queueLocationLabel.backgroundColor=UIColor.lightGray
        }
        
        self.view.addSubview(queueLocationLabel)
        
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
        
        if(user?.displayName != nil){
            queueNameLabel.text = (user?.displayName)!
            queueNameLabel.backgroundColor=UIColor.blue
            queueNameLabel.textColor=UIColor.white
        }
        else {
            queueNameLabel.text = "..."
            queueNameLabel.backgroundColor=UIColor.lightGray
            queueNameLabel.textColor=UIColor.black
        }
        
        
        if(user?.displayName != nil){
            if (Queue.userLocationFound != true){
                myList.removeAll()
                handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
                    //Adding keys to myList instead of the values now to allow for easy deleting of top person
                    if let item = snapshot.value as! String? {
                        
                        if(item == user?.email) {
                            self.queueLocationLabel.text = String(self.myList.count-1)
                            Queue.userLocationFound = true
                        }
                        if (!Queue.userLocationFound){
                            self.myList.append(item)
                        }
                        
                    }
                })
                
                handle2 = ref?.child("Queues").child((user?.displayName!)!).observe(.childRemoved, with: { (snapshot) in
                    //Adding keys to myList instead of the values now to allow for easy deleting of top person
                    if let item = snapshot.value as! String? {
                        
                        if let index = self.myList.index(of: item) {
                            self.myList.remove(at:index)
                            self.queueLocationLabel.text = String(self.myList.count-1)
                            print(self.myList)
                            
                        }
                        
                    }
                })
            }
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
