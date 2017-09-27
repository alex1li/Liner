//
//  QueueViewController.swift
//  Liner
//
//  Created by Alexander Li on 8/9/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class QueueViewController: UIViewController {
    
    var myList:[String] = []
    var handle: DatabaseHandle?
    var handle2: DatabaseHandle?
    var handle3: DatabaseHandle?
    var ref: DatabaseReference?
    var personList:[String] = []
    var truth: Bool! = true
    
    var inThisQueue = false
    var thisQueue = Queue.chosenQueue
    
    var peopleAhead:Int!
    
    //Graphics
    var joinButton: UIButton!
    var peopleAheadLabel: UILabel!
    var queueNameLabel: UILabel!
    var peopleAheadMarkerLabel: UILabel!
    var thisQueueMarkerLabel: UILabel!
    
    let labelHeight = 100
    let searchButtonHeight: CGFloat = 80
    
    let user = Auth.auth().currentUser
    var alreadyInQueue: String?
    var queueStatusChanged: Bool = false
    var changeRequest: UserProfileChangeRequest?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "lynn"
        view.backgroundColor = .white
        
        
        joinButton = UIButton(frame: CGRect(x: 10, y: view.frame.height-searchButtonHeight-10, width: view.frame.width-20, height: searchButtonHeight))
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1), for: .normal)
        joinButton.backgroundColor = .white
        joinButton.layer.cornerRadius = 30
        joinButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1).cgColor
        joinButton.layer.borderWidth = 1.5
        joinButton.addTarget(self, action:#selector(join), for: .touchUpInside)
        joinButton.addTarget(self, action:#selector(pressUp), for: .touchUpOutside)
        joinButton.addTarget(self, action:#selector(pressDown), for: .touchDown)
        view.addSubview(joinButton)

        
        //People in line label
        peopleAheadLabel = UILabel()
        peopleAheadLabel.frame = CGRect(x: 140, y: 300, width: Int(view.frame.width/2), height: labelHeight*2)
        peopleAheadLabel.textAlignment = .center
        peopleAheadLabel.numberOfLines=1
        peopleAheadLabel.text = "0"
        peopleAheadLabel.textColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        peopleAheadLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 180)
        peopleAheadLabel.backgroundColor=UIColor.white
        view.addSubview(peopleAheadLabel)
        
        //loading indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        //queue name label
        let labelWidth = Int(view.frame.width)
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 140, y: 100, width: labelWidth/2, height: labelHeight)
        queueNameLabel.textAlignment = .center
        queueNameLabel.text = thisQueue
        queueNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        queueNameLabel.textColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        queueNameLabel.backgroundColor=UIColor.white
        queueNameLabel.lineBreakMode = .byWordWrapping
        queueNameLabel.numberOfLines = 0;
        self.view.addSubview(queueNameLabel)
        
        //queueNameLabel = UILabel()
        //queueNameLabel.frame = CGRect(x: 0, y: 60, width: view.frame.size.width, height: 100)
        //queueNameLabel.textAlignment = .center
        //queueNameLabel.numberOfLines=1
        
        //queueNameLabel.textColor=UIColor.white
        //queueNameLabel.font=UIFont.systemFont(ofSize: 30)
        //queueNameLabel.backgroundColor=UIColor.lightGray
        //view.addSubview(queueNameLabel)
        
        //Marker Labels
        peopleAheadMarkerLabel = UILabel()
        peopleAheadMarkerLabel.frame = CGRect(x: 20, y: 270, width: 100, height: 200)
        peopleAheadMarkerLabel.textAlignment = .center
        peopleAheadMarkerLabel.lineBreakMode = .byWordWrapping
        peopleAheadMarkerLabel.numberOfLines = 0;
        peopleAheadMarkerLabel.text = "people ahead"
        peopleAheadMarkerLabel.textColor=UIColor.black
        peopleAheadMarkerLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        peopleAheadMarkerLabel.backgroundColor=UIColor.white
        self.view.addSubview(peopleAheadMarkerLabel)
        
        thisQueueMarkerLabel = UILabel()
        thisQueueMarkerLabel.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        thisQueueMarkerLabel.textAlignment = .center
        thisQueueMarkerLabel.numberOfLines=1
        thisQueueMarkerLabel.text = "this queue"
        thisQueueMarkerLabel.textColor=UIColor.black
        thisQueueMarkerLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        thisQueueMarkerLabel.backgroundColor=UIColor.white
        self.view.addSubview(thisQueueMarkerLabel)
        
        ref = Database.database().reference()
        
        handle = ref?.child("Queues").child(thisQueue!).observe(.childAdded, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if let item = snapshot.key as String? {
                self.myList.append(item)
                self.peopleAhead = self.myList.count-1
                self.peopleAheadLabel.text = String(self.peopleAhead)

            }
        })
        if (Queue.linesJoined.contains(thisQueue!)){
            inThisQueue = true
            self.view.backgroundColor = .blue
        }
        handle2 = ref?.child("Queues").child(thisQueue!).observe(.childRemoved, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if (snapshot.key as String?) != nil {
                self.myList.remove(at: 0)
                self.peopleAhead = self.myList.count-1
                self.peopleAheadLabel.text = String(self.peopleAhead)
                print("child removed")
                print(self.myList.count)
            }
        })
        
        if (user?.displayName != nil){
            alreadyInQueue = user?.displayName
        }
        
        handle3 = ref?.child("QueueInfo").child(thisQueue!).observe(.childAdded, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if let item = snapshot.value as! String? {
                
                if(item == "Closed") {
                    self.truth = false;
                    self.joinButton.setTitle("Closed", for: .normal)
                    self.joinButton.isEnabled = false;
                    self.joinButton.setTitleColor(UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
                    self.joinButton.layer.borderColor = UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
                    
                }
                else {
                    self.truth = true;
                    print("True")
                }
                
                
            }
        })
        if (Queue.linesJoined.contains(thisQueue!)){
            inThisQueue = true
            self.view.backgroundColor = .blue
        }
        

    }
    
    
    func join(_ sender:Any){
        pressUp(joinButton)
        if (user?.displayName == nil || user?.displayName == ""){
            self.createAlert(title: "Join Confirmation", message: "Do you want to join this queue?")
        }
        else{
            // create the alert
            let alert = UIAlertController(title: "Already in a queue", message: "You can only join 1 queue at a time. Please leave your current queue before joining other queues.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func pressUp(_ sender:Any){
        joinButton.backgroundColor = .white
    }
    
    func pressDown(_ sender:Any){
        joinButton.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1)
    }
    
    func confirmPressed(){
        activityIndicator.startAnimating()
        while(user?.displayName != thisQueue){
            print("waiting")
        }
        activityIndicator.stopAnimating()
        for  controller in (self.navigationController?.viewControllers)!{
            if controller.isKind(of: StatusViewController.self){
                controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
        print("Joined Queue")
    }
    
    func updateUserInfo(){
        changeRequest = (user?.createProfileChangeRequest())!
        changeRequest?.displayName = thisQueue
        changeRequest?.commitChanges(completion: { (error) in})
        Queue.userLocationFound = false
        
    }
    
    func addChildToQueue(childName: String){
        let currentDateTime = Date()
        let user = Auth.auth().currentUser
        ref?.child("Queues").child(thisQueue!).child(String(describing: currentDateTime)).setValue(user?.email)
        //ref?.child("Queues").child(thisQueue!).child(String(describing: currentDateTime)).setPriority(myList.count+1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref?.child("Queues").child(thisQueue!).removeAllObservers()
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(action) in
            self.addChildToQueue(childName: (self.user?.email)!)
            self.updateUserInfo()
            alert.dismiss(animated: true, completion: nil)
            self.confirmPressed()
            
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
