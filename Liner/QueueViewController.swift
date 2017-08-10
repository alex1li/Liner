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
    var ref: DatabaseReference?
    var personList:[String] = []
    
    var inThisQueue = false
    var thisQueue = Queue.chosenQueue
    
    var peopleAhead:Int!
    
    //Graphics
    var joinButton: UIButton!
    var peopleAheadLabel: UILabel!
    
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
        joinButton = UIButton(frame: CGRect(x: 60, y: 200, width: 300, height: 300))
        joinButton.setTitle("Join", for: .normal)
        joinButton.addTarget(self, action:#selector(join), for: .touchUpInside)
        joinButton.titleLabel?.textColor = .red
        joinButton.setTitleColor(.red, for: .normal)
        joinButton.titleLabel!.font = UIFont(name:"Avenir", size:30)
        joinButton.titleLabel!.textAlignment = .left
        view.addSubview(joinButton)
        
        //People in line label
        peopleAheadLabel = UILabel()
        peopleAheadLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        peopleAheadLabel.textAlignment = .center
        peopleAheadLabel.numberOfLines=1
        peopleAheadLabel.text = "..."
        peopleAheadLabel.textColor=UIColor.green
        peopleAheadLabel.font=UIFont.systemFont(ofSize: 52)
        peopleAheadLabel.backgroundColor=UIColor.lightGray
        view.addSubview(peopleAheadLabel)
        
        //loading indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        
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
 
    }
    
    
    func join(_ sender:Any){
        activityIndicator.startAnimating()
        addChildToQueue(childName: (user?.email)!)
        changeRequest = (user?.createProfileChangeRequest())!
        changeRequest?.displayName = thisQueue
        changeRequest?.commitChanges(completion: { (error) in})
        Queue.userLocationFound = false
        while(user?.displayName != thisQueue){
            print("waiting")
        }
        for  controller in (self.navigationController?.viewControllers)!{
            if controller.isKind(of: StatusViewController.self){
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
        print("Joined Queue")
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

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
