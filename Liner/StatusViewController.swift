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
    
    //MARK: Dynamic components
    let labelWidth = 300
    let labelHeight = 100
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
    
    var leaveButtonPath: Bool! //Controls whether to show removal notice alert
    
    
    override func viewDidLoad() {
        print("View did load")
        view.backgroundColor = .white
        
        self.title = "Status"
        
        ref = Database.database().reference()
        
        //Leave button
        leaveButton = UIButton(frame: CGRect(x: 10, y: 580, width: 100, height: 100))
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.addTarget(self, action:#selector(leave), for: .touchUpInside)
        leaveButton.titleLabel?.textColor = .red
        leaveButton.setTitleColor(.red, for: .normal)
        leaveButton.titleLabel!.font = UIFont(name:"Avenir", size:30)
        leaveButton.titleLabel!.textAlignment = .left
        leaveButton.isEnabled = false
        leaveButton.isHidden = true
        leaveButtonPath = false
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
        yourLocationLabel.text = "Place"
        yourLocationLabel.textColor=UIColor.black
        yourLocationLabel.font=UIFont.systemFont(ofSize: 20)
        yourLocationLabel.backgroundColor=UIColor.white
        self.view.addSubview(yourLocationLabel)
        
        //Queue name Label
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 50, y: 180, width: labelWidth, height: labelHeight)
        queueNameLabel.textAlignment = .center
        queueNameLabel.numberOfLines=1
        queueNameLabel.font=UIFont.systemFont(ofSize: 30)
        self.view.addSubview(queueNameLabel)
        
        //Queue location label
        queueLocationLabel = UILabel()
        queueLocationLabel.frame = CGRect(x: 50, y: 430, width: labelWidth, height: labelHeight)
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        
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
        //print(user?.displayName)
        
        //Queue Name
        if(user?.displayName != nil && user?.displayName != ""){
            leaveButton.isEnabled = true
            leaveButton.isHidden = false
            queueNameLabel.text = (user?.displayName)!
            queueNameLabel.backgroundColor=UIColor.blue
            queueNameLabel.textColor=UIColor.white
            
            handleDatabase()
        }
        else {
            queueNameLabel.text = "..."
            queueNameLabel.backgroundColor=UIColor.lightGray
            queueNameLabel.textColor=UIColor.black
            
            queueLocationLabel.text = "..."
            queueLocationLabel.textColor=UIColor.black
            queueLocationLabel.backgroundColor=UIColor.lightGray
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [],
                       animations: {
                        self.queueNameLabel.frame.size.width = CGFloat(self.labelWidth)
                        self.queueNameLabel.frame.size.height = CGFloat(self.labelHeight)
                        self.queueLocationLabel.frame.size.width = CGFloat(self.labelWidth)
                        self.queueLocationLabel.frame.size.height = CGFloat(self.labelHeight)
        }, 
                       completion: nil
        )
        
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queueNameLabel.frame.size.width = 0;
        queueNameLabel.frame.size.height = 0;
        queueLocationLabel.frame.size.width = 0;
        queueLocationLabel.frame.size.height = 0;
    }
    
    
    func handleDatabase(){
        queueLocationLabel.textColor=UIColor.white
        queueLocationLabel.backgroundColor=UIColor.blue
        if (Queue.userLocationFound != true){
            print("creating handles")
            myList.removeAll()
            handle = ref?.child("Queues").child((user?.displayName!)!).observe(.childAdded, with: { (snapshot) in
                //Adding keys to myList instead of the values now to allow for easy deleting of top person
                if let item = snapshot.value as! String? {
                    
                    if(item == self.user?.email) {
                        //print(self.myList)
                        self.queueLocationLabel.text = String(self.myList.count)
                        Queue.userLocationFound = true
                        if (snapshot.key as String?) != nil{
                            //print(snapshot.key)
                            self.myKey = snapshot.key
                        }
                    }
                    if (!Queue.userLocationFound){
                        self.myList.append(item)
                    }
                }
            })
            
            print(myList)
            
            if (user?.displayName != nil && queueLocationLabel.text == nil){
                print("not in list")
            }
            
            
            
            handle2 = ref?.child("Queues").child((user?.displayName!)!).observe(.childRemoved, with: { (snapshot) in
                if let item = snapshot.value as! String? {
                    print("child removed")
                    print(item)
                    if(item == self.user?.email){
                        
                        print("self detected")
                        print(self.leaveButtonPath)
                        
                        //if (!self.leaveButtonPath){
                            print("enter if")
                            self.leaveActions()
                        //    self.leaveButtonPath = false
                        //}
                    }
                    else if let index = self.myList.index(of: item) {
                        self.myList.remove(at:index)
                        self.queueLocationLabel.text = String(self.myList.count)
                        //print(self.myList)
                    }
                }
            })
        }
    }
    
    func leave(_ sender:Any){
        self.createLeaveAlert(title: "Leave Confirmation", message: "You will leave this queue")
    }
    
    func leaveActions(){
        
        activityIndicator.startAnimating()
        
        changeRequest = (user?.createProfileChangeRequest())!
        changeRequest?.displayName = ""
        changeRequest?.commitChanges(completion: { (error) in})
        
        Queue.userLocationFound = false
        ref?.child("Queues").child((user?.displayName!)!).removeAllObservers()
        
        while(user?.displayName != ""){
            print("waiting")
        }
        //print(user?.displayName)
        activityIndicator.stopAnimating()
        
        print(leaveButtonPath)
        if (!leaveButtonPath){
            createRemovedAlert(title: "Removal Notice", message: "You have been removed from your current queue")
        }
        leaveButtonPath = false
        
        queueLocationLabel.text = "..."
        queueLocationLabel.textColor=UIColor.black
        queueLocationLabel.backgroundColor=UIColor.lightGray
        
        queueNameLabel.text = "..."
        queueNameLabel.backgroundColor=UIColor.lightGray
        queueNameLabel.textColor=UIColor.black
        leaveButton.isEnabled = false
        leaveButton.isHidden = true
        
        //leaveButtonPath = false
        
        //myList.removeAll()
        //print("left")
        //print(myList)
    }
    
    func logOut(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func createLeaveAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(action) in
            self.leaveButtonPath = true
            self.ref?.child("Queues").child((self.user?.displayName!)!).child(self.myKey).removeValue()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createRemovedAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
