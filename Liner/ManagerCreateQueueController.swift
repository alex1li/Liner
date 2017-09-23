//
//  ManagerCreateQueueController.swift
//  Liner
//
//  Created by Rohan Patel on 8/20/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase




class ManagerCreateQueueController: UIViewController, UITextFieldDelegate {
    
    var queueName: UITextField!
    var queueNameLabel : UILabel!
    var createQueue: UIButton!
    var changeRequest: UserProfileChangeRequest?
    var ref: DatabaseReference!
    var handle: DatabaseHandle!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        queueNameLabel = UILabel(frame: CGRect(x: 30, y: 100, width: view.frame.size.width-60, height: 30))
        queueNameLabel.textColor = .black
        queueNameLabel.textAlignment = .center
        queueNameLabel.text = "create a queue"
        queueNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        view.addSubview(queueNameLabel)
        
        queueName = UITextField(frame: CGRect(x: 30, y: 150, width: view.frame.size.width-60, height: 40))
        queueName.placeholder = "Queue Name"
        queueName.backgroundColor = .white
        queueName.borderStyle = UITextBorderStyle.roundedRect
        view.addSubview(queueName)
        
        ref = Database.database().reference()
        
        createQueue = UIButton(frame: CGRect(x: 50, y: 250, width: view.frame.size.width-100, height: 60))
        createQueue.setTitle("Create", for: .normal)
        createQueue.layer.cornerRadius = 30
        createQueue.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1).cgColor
        createQueue.layer.borderWidth = 1.5
        createQueue.titleLabel?.textColor = .black
        createQueue.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1), for: .normal)
        createQueue.titleLabel!.textAlignment = .center
        createQueue.addTarget(self, action: #selector(createdQueue), for: .touchUpInside)
        createQueue.addTarget(self, action: #selector(pressDownCreate), for: .touchDown)
        createQueue.addTarget(self, action: #selector(pressUpCreate), for: .touchUpOutside)
        view.addSubview(createQueue)
  

        // Do any additional setup after loading the view.
    }
    
    func createdQueue() {
        
        createQueue.backgroundColor = .white
        
        if(queueName.text != nil){
            
            let user = Auth.auth().currentUser
            changeRequest = (user?.createProfileChangeRequest())!
            changeRequest?.displayName = queueName.text!
            changeRequest?.commitChanges(completion: { (error) in})
            
            
            while(user?.displayName == nil || user?.displayName == "") {
            }
            print("change request")
            print(user?.displayName)
            
            ref?.child("Queues").child((user?.displayName)!).setValue("tempVal")
            let creationTime = Date()
            ref?.child("Queues").child((user?.displayName)!).child(String(describing: creationTime)).setValue("Created")
            ref?.child("QueueInfo").child((user?.displayName)!).setValue("tempVal")
            ref?.child("QueueInfo").child((user?.displayName)!).child("OpenStatus").setValue("Open")
            
            

            self.navigationController?.popViewController(animated: true)
            
            print("queue added")
        }
        else{
            print("no queue name")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (queueNameLabel.text != nil) {
            createdQueue()
        }
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func pressUpCreate(_ sender:Any){
        createQueue.backgroundColor = .white
    }
    
    func pressDownCreate(_ sender:Any){
        createQueue.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
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
