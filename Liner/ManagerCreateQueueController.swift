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
        
        queueNameLabel = UILabel(frame: CGRect(x: 85, y: 100, width: 300, height: 30))
        queueNameLabel.textColor = .black
        queueNameLabel.text = "Enter Queue Name Below"
        view.addSubview(queueNameLabel)
        
        queueName = UITextField(frame: CGRect(x: 30, y: 150, width: 340, height: 40))
        queueName.backgroundColor = .white
        queueName.layer.borderWidth = 1
        queueName.layer.borderColor = UIColor.black.cgColor
        
        ref = Database.database().reference()
        
        createQueue = UIButton(frame: CGRect(x: 50, y: 200, width: 300, height: 100))
        createQueue.setTitle("Create Queue", for: .normal)
        createQueue.titleLabel?.textColor = .black
        createQueue.setTitleColor(.black, for: .normal)
        createQueue.titleLabel!.textAlignment = .left
        view.addSubview(createQueue)

        
        createQueue.addTarget(self, action: #selector(createdQueue), for: .touchUpInside)
        
        view.addSubview(createQueue)
        
        
        view.addSubview(queueName)
        

        

        // Do any additional setup after loading the view.
    }
    
    func createdQueue() {
        
        if(queueName.text != nil){
            
            let user = Auth.auth().currentUser
            changeRequest = (user?.createProfileChangeRequest())!
            changeRequest?.displayName = queueName.text! + "-Open"
            changeRequest?.commitChanges(completion: { (error) in})
            
            
            while(user?.displayName == nil) {
                
                
            }
            
            ref?.child("Queues").child((user?.displayName)!).setValue("tempVal")
            let creationTime = Date()
            ref?.child("Queues").child((user?.displayName)!).child(String(describing: creationTime)).setValue("Created")

            self.navigationController?.popViewController(animated: true)
            
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
