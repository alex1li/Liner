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
    var noQueueLabel:UILabel!
    
    var searchButton: UIButton!
    var leaveButton: UIButton!
    
    var searchButtonHeight: CGFloat = 80
    var leaveButtonHeight: CGFloat = 80
    var leaveButtonWidth: CGFloat = 80
    
    //MARK: Dynamic components
    var labelWidth: Int!
    let labelHeight = 100
    var queueNameLabel:UILabel!
    var queueLocationLabel:UILabel!
    
    var location: Int!
    
    var tableView: UITableView!
    var handle: DatabaseHandle?
    var handle2: DatabaseHandle?
    var ref: DatabaseReference?
    //var count: Int!
    //var found: Bool!
    
    //MARK: Leave variables
    var myKey: String!
    var changeRequest: UserProfileChangeRequest?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var myList:[String] = []
    
    var user = Auth.auth().currentUser
    var inQueue: Bool!
    
    
    var leaveButtonPath: Bool! //Controls whether to show removal notice alert
    
    
    override func viewDidLoad() {
        print("View did load")
        view.backgroundColor = .white
        
        self.title = "Status"
        
        ref = Database.database().reference()
        
        if (user?.displayName == nil || user?.displayName == ""){
            inQueue = false
        }
        else{
            inQueue = true
        }
        
        //Leave button
        if (!inQueue){
            leaveButton = UIButton(frame: CGRect(x: 0, y: view.frame.height-leaveButtonHeight-10, width: 0, height: leaveButtonHeight))
        }
        else{
            leaveButton = UIButton(frame: CGRect(x: 0, y: view.frame.height-leaveButtonHeight, width: leaveButtonWidth, height: leaveButtonHeight))
        }
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.addTarget(self, action:#selector(leave), for: .touchUpInside)
        leaveButton.backgroundColor = .white
        leaveButton.setTitleColor(UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        leaveButton.layer.borderColor = UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        leaveButton.layer.borderWidth = 1.5
        leaveButton.layer.cornerRadius = 30
        leaveButton.isEnabled = false
        //leaveButton.isHidden = true
        leaveButtonPath = false
        view.addSubview(leaveButton)
        
        
        //Search button
        if (!inQueue){
            searchButton = UIButton(frame: CGRect(x: 10, y: view.frame.height-searchButtonHeight-10, width: view.frame.width-20, height: searchButtonHeight))
        }
        else{
            searchButton = UIButton(frame: CGRect(x: 0+leaveButtonWidth, y: view.frame.height-searchButtonHeight, width: view.frame.width-leaveButtonWidth, height: searchButtonHeight))
        }
        searchButton.setTitle("Search Queues", for: .normal)
        searchButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1), for: .normal)
        searchButton.backgroundColor = .white
        searchButton.addTarget(self, action: #selector(joinQueue), for: .touchUpInside)
        searchButton.layer.cornerRadius = 30
        searchButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1).cgColor
        searchButton.layer.borderWidth = 1.5
        view.addSubview(searchButton)
        
        
        //Your Location Label
        
        displayYourLocationLabel()
        displayYourQueueLabel()
        if (!inQueue){
            removeYourLocationLabel()
            removeYourQueueLabel()
        }
        
        if (!inQueue){
            displayNotInQueue()
        }
        
        //Queue name Label
        labelWidth = Int(view.frame.width)
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 140, y: 100, width: labelWidth/2, height: labelHeight)
        queueNameLabel.textAlignment = .center
        queueNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        self.view.addSubview(queueNameLabel)
        
        //Queue location label
        queueLocationLabel = UILabel()
        queueLocationLabel.frame = CGRect(x: 140, y: 300, width: labelWidth/2, height: labelHeight*2)
        queueLocationLabel.textAlignment = .center
        queueLocationLabel.numberOfLines=1
        queueLocationLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 180)
        
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
            
            displayYourLocationLabel()
            displayYourQueueLabel()
            
            leaveButton.isEnabled = true
            //leaveButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.searchButton.frame = CGRect(x: 0+self.leaveButtonWidth, y: self.view.frame.height-self.searchButtonHeight, width: self.view.frame.width-self.leaveButtonWidth, height: self.searchButtonHeight)
                
                self.leaveButton.frame = CGRect(x: 0, y: self.view.frame.height-self.leaveButtonHeight, width: self.leaveButtonWidth, height: self.leaveButtonHeight)
                
            }, completion: nil)
            
            
            
            queueNameLabel.text = (user?.displayName)!
            queueNameLabel.backgroundColor = .white
            queueNameLabel.textColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
            
            handleDatabase()
        }
        else {
            
            displayNotInQueue()
            
            /*
            queueNameLabel.text = "..."
            queueNameLabel.backgroundColor=UIColor.white
            queueNameLabel.textColor=UIColor.black
            
            queueLocationLabel.text = "..."
            queueLocationLabel.textColor=UIColor.black
            queueLocationLabel.backgroundColor=UIColor.white
            */
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [],
                       animations: {
                        //self.queueNameLabel.frame.size.width = CGFloat(self.labelWidth)
                        //self.queueNameLabel.frame.size.height = CGFloat(self.labelHeight)
                        //self.queueLocationLabel.frame.size.width = CGFloat(self.labelWidth/2)
                        self.queueLocationLabel.frame.size.height = CGFloat(self.labelHeight*2)
        }, 
                       completion: nil
        )
        
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        removeNotInQueue()
        
        if(user?.displayName != nil && user?.displayName != ""){
            removeYourLocationLabel()
        }
        
        //queueNameLabel.frame.size.width = 0;
        //queueNameLabel.frame.size.height = 0;
        //queueLocationLabel.frame.size.width = 0;
        queueLocationLabel.frame.size.height = 0;
    }
    
    
    func handleDatabase(){
        queueLocationLabel.textColor=UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        queueLocationLabel.backgroundColor=UIColor.white
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
        print("leaveActions called")
        
        activityIndicator.startAnimating()
        
        Queue.userLocationFound = false
        
        
        if let b = self.ref?.child("Queues").child((self.user?.displayName!)!).removeAllObservers(){
            print("observers removed")
        }
        else{
            print(user?.displayName!)
        }
        
        
        
        changeRequest = (user?.createProfileChangeRequest())!
        changeRequest?.displayName = ""
        changeRequest?.commitChanges(completion: { (error) in})
        
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
        
        displayNotInQueue()
        /*
        queueLocationLabel.text = "..."
        queueLocationLabel.textColor=UIColor.black
        queueLocationLabel.backgroundColor=UIColor.white
        
        queueNameLabel.text = "..."
        queueNameLabel.backgroundColor=UIColor.white
        queueNameLabel.textColor=UIColor.black
        leaveButton.isEnabled = false
        */
        //leaveButton.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.searchButton.frame = CGRect(x: 10, y: self.view.frame.height-self.searchButtonHeight, width: self.view.frame.width-20, height: self.searchButtonHeight)
            
            self.leaveButton.frame = CGRect(x: 0, y: self.view.frame.height-self.leaveButtonHeight, width: 0, height: self.leaveButtonHeight)
            
        }, completion: nil)
        
        
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
    
    //MARK: Display functions
    func displayNotInQueue(){
        noQueueLabel = UILabel()
        noQueueLabel.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height-180)
        noQueueLabel.textAlignment = .center
        noQueueLabel.numberOfLines=3
        noQueueLabel.text = "no queue joined"
        noQueueLabel.textColor=UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        noQueueLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 100)
        //noQueueLabel.font=UIFont.systemFont(ofSize: 100)
        noQueueLabel.backgroundColor=UIColor.white
        noQueueLabel.tag = 1
        view.addSubview(noQueueLabel)
    }
    
    func displayYourLocationLabel(){
        yourLocationLabel = UILabel()
        yourLocationLabel.frame = CGRect(x: 20, y: 270, width: 100, height: 200)
        yourLocationLabel.textAlignment = .center
        yourLocationLabel.numberOfLines=1
        yourLocationLabel.text = "place in line"
        yourLocationLabel.textColor=UIColor.black
        yourLocationLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        yourLocationLabel.backgroundColor=UIColor.white
        self.view.addSubview(yourLocationLabel)
    }
    
    func displayYourQueueLabel(){
        yourQueueLabel = UILabel()
        yourQueueLabel.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        yourQueueLabel.textAlignment = .center
        yourQueueLabel.numberOfLines=1
        yourQueueLabel.text = "your queue"
        yourQueueLabel.textColor=UIColor.black
        yourQueueLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        yourQueueLabel.backgroundColor=UIColor.white
        self.view.addSubview(yourQueueLabel)
    }
    
    func removeYourLocationLabel(){
        yourLocationLabel.frame.size.height = 0
    }
    
    func removeYourQueueLabel(){
        yourQueueLabel.frame.size.height = 0
    }
    
    func removeNotInQueue(){
        print("removeNotInQueue")
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No tage found")
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
