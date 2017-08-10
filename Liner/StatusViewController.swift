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
    
    //MARK: Display Components
    var yourQueueLabel:UILabel!
    var yourLocationLabel:UILabel!
    var queueNameLabel:UILabel!
    var queueLocationLabel:UILabel!
    
    var tableView: UITableView!
    var handle: DatabaseHandle?
    var handle2: DatabaseHandle?
    var ref: DatabaseReference?
    //var count: Int!
    //var found: Bool!
    
    //MARK: Leave variables
    var leaveButton: UIButton!
    var myKey: String!
    var changeRequest: UserProfileChangeRequest?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var myList:[String] = []
    
    var user = Auth.auth().currentUser

    
    
    
    override func viewDidLoad() {
        print("View did load")
        view.backgroundColor = .white
        
        ref = Database.database().reference()
        
        //Leave button
        leaveButton = UIButton(frame: CGRect(x: 50, y: 550, width: 100, height: 100))
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.addTarget(self, action:#selector(leave), for: .touchUpInside)
        leaveButton.titleLabel?.textColor = .red
        leaveButton.setTitleColor(.red, for: .normal)
        leaveButton.titleLabel!.font = UIFont(name:"Avenir", size:30)
        leaveButton.titleLabel!.textAlignment = .left
        view.addSubview(leaveButton)
        
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
        self.view.addSubview(queueNameLabel)
        
        //Queue location label
        queueLocationLabel = UILabel()
        queueLocationLabel.frame = CGRect(x: 50, y: 430, width: 300, height: 100)
        queueLocationLabel.textAlignment = .center
        queueLocationLabel.numberOfLines=1
        queueLocationLabel.font=UIFont.systemFont(ofSize: 30)
        
        //loading indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        Queue.userLocationFound = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
        ref = Database.database().reference()
        print(user?.displayName)
        
        //Queue Name
        if(user?.displayName != nil && user?.displayName != ""){
            leaveButton.isEnabled = true
            queueNameLabel.text = (user?.displayName)!
            queueNameLabel.backgroundColor=UIColor.blue
            queueNameLabel.textColor=UIColor.white
        }
        else {
            queueNameLabel.text = "..."
            queueNameLabel.backgroundColor=UIColor.lightGray
            queueNameLabel.textColor=UIColor.black
        }

        //Queue Location
        if(user?.displayName != nil && user?.displayName != ""){
            handleDatabase()
        }
        else{
            queueLocationLabel.text = "..."
            queueLocationLabel.textColor=UIColor.black
            queueLocationLabel.backgroundColor=UIColor.lightGray
        }
        super.viewDidAppear(true)
        
    }
    
    
    func handleDatabase(){
        queueLocationLabel.textColor=UIColor.white
        queueLocationLabel.backgroundColor=UIColor.blue
        if (Queue.userLocationFound != true){
            myList.removeAll()
            handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                    if(item == self.user?.email) {
                        self.queueLocationLabel.text = String(self.myList.count-1)
                        Queue.userLocationFound = true
                        if (snapshot.key as String?) != nil{
                            print(snapshot.key)
                            self.myKey = snapshot.key
                        }
                    }
                    if (!Queue.userLocationFound){
                        self.myList.append(item)
                    }
                    
                }
            })
            
            handle2 = ref?.child("Queues").child((user?.displayName!)!).observe(.childRemoved, with: { (snapshot) in
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
    
    func leave(_ sender:Any){
        activityIndicator.startAnimating()
        ref?.child("Queues").child((user?.displayName!)!).child(myKey).setValue(nil)
        changeRequest = (user?.createProfileChangeRequest())!
        changeRequest?.displayName = ""
        changeRequest?.commitChanges(completion: { (error) in})
        while(user?.displayName != ""){
            print("waiting")
        }
        print(user?.displayName)
        activityIndicator.stopAnimating()
        print("left queue")
        queueLocationLabel.text = "..."
        queueLocationLabel.textColor=UIColor.black
        queueLocationLabel.backgroundColor=UIColor.lightGray
        queueNameLabel.text = "..."
        queueNameLabel.backgroundColor=UIColor.lightGray
        queueNameLabel.textColor=UIColor.black
        leaveButton.isEnabled = false
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
