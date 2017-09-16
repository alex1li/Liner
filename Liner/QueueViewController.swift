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
    
    let user = Auth.auth().currentUser
    var alreadyInQueue: String?
    var queueStatusChanged: Bool = false
    var changeRequest: UserProfileChangeRequest?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = thisQueue
        view.backgroundColor = .white
        
        //Join button
        
        
        
        
        //People in line label
        peopleAheadLabel = UILabel()
        peopleAheadLabel.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        peopleAheadLabel.textAlignment = .center
        peopleAheadLabel.numberOfLines=1
        peopleAheadLabel.text = "..."
        peopleAheadLabel.textColor=UIColor.black
        peopleAheadLabel.font=UIFont.systemFont(ofSize: 72)
        peopleAheadLabel.backgroundColor=UIColor.white
        view.addSubview(peopleAheadLabel)
        
        //loading indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        //queue name label
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 0, y: 60, width: view.frame.size.width, height: 100)
        queueNameLabel.textAlignment = .center
        queueNameLabel.numberOfLines=1
        queueNameLabel.text = thisQueue
        queueNameLabel.textColor=UIColor.white
        queueNameLabel.font=UIFont.systemFont(ofSize: 30)
        queueNameLabel.backgroundColor=UIColor.lightGray
        view.addSubview(queueNameLabel)
        
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
        
        
            joinButton = UIButton(frame: CGRect(x: 0, y: view.frame.size.height-100, width: view.frame.size.width, height: 100))
            joinButton.setTitle("Join", for: .normal)
            joinButton.addTarget(self, action:#selector(join), for: .touchUpInside)
            joinButton.addTarget(self, action:#selector(pressUp), for: .touchUpOutside)
            joinButton.addTarget(self, action:#selector(pressDown), for: .touchDown)
            joinButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 230/255, blue: 60/255, alpha: 1)
            joinButton.titleLabel?.textColor = .white
            joinButton.setTitleColor(.white, for: .normal)
            joinButton.titleLabel!.font = UIFont(name:"Avenir", size:30)
            joinButton.titleLabel!.textAlignment = .left
            view.addSubview(joinButton)
        
   

 
    }
    
    
    func join(_ sender:Any){
        pressUp(joinButton)
        self.createAlert(title: "Join Confirmation", message: "Do you want to join this queue?")
    }
    
    func pressUp(_ sender:Any){
        joinButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 230/255, blue: 60/255, alpha: 1)
    }
    
    func pressDown(_ sender:Any){
        joinButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 130/255, blue: 60/255, alpha: 1)
    }
    
    func confirmPressed(){
        activityIndicator.startAnimating()
        while(user?.displayName != thisQueue){
            print("waiting")
        }
        activityIndicator.stopAnimating()
        for  controller in (self.navigationController?.viewControllers)!{
            if controller.isKind(of: StatusViewController.self){
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
