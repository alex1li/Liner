//
//  ViewController.swift
//  firebasetest7
//
//  Created by Rohan Patel on 7/21/17.
//  Copyright © 2017 Rohan Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var Button1: UIButton!
    var myTableView: UITableView!
    var myTextField: UITextField!
    
    var myList:[String] = []
    var handle: DatabaseHandle?
    var ref: DatabaseReference?
    var count = 2;
    var masterList:[[String]] = [[], [], []]
    
    
    
    
     func saveBtn(_ sender: Any) {
        
        // ignore for me
        Analytics.setUserProperty("chicken", forName: "favorite_food")

        // for you
        if (myTextField.text != "") {
            
            // dont know whats going on here, you can take this stuff over
            // just what happens when you click save btn
            ref?.child("list").childByAutoId().setValue(myTextField.text)
            myTextField.text = ""
            self.myTableView.reloadData()
            
            
            if(count == 2) {
                
                ref?.child("test3").childByAutoId().setValue(myTextField.text)
                myTextField.text = ""
                self.myTableView.reloadData()
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = "ro"
                
                changeRequest?.commitChanges(completion: { (error) in
                
                })
                
                Auth.auth().currentUser?.createProfileChangeRequest().displayName = "ro"


                
            }

            
            
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1;
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.height/2;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // initalizes each cell, take this over, count was just a way of doing it
        // im sure your way is better
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        
        
        if(count == 2)
        {        cell.textLabel?.text = String(masterList[2].count)
            print(masterList[2].count)
            cell.textLabel?.font = UIFont(name:"Avenir", size:100)
            cell.textLabel?.textAlignment = .center
            
            //cell.textLabel?.text = myList[indexPath.row]
        }
        return cell
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "paris"))
        
        print(count);
        
        myTableView = UITableView(frame: view.frame)
        myTableView.dataSource = self
        myTableView.delegate = self
        view.addSubview(myTableView)
        
        Button1 = UIButton(frame: CGRect(x: 60, y: 200, width: 300, height: 300))
        Button1.setTitle("Add to Queue?", for: .normal)
        Button1.addTarget(self, action:#selector(saveBtn), for: .touchUpInside)
            Button1.titleLabel?.textColor = .red
        Button1.setTitleColor(.red, for: .normal)
        Button1.titleLabel!.font = UIFont(name:"Avenir", size:30)
        Button1.titleLabel!.textAlignment = .left
        view.addSubview(Button1)
        
        
        myTextField = UITextField(frame: CGRect(x: 0, y: 100, width: 500, height: 50))
        myTextField.layer.borderWidth = 5

        myTextField.backgroundColor = .white
        myTextField.layer.borderColor = UIColor.black.cgColor
        view.addSubview(myTextField)
        
        ref = Database.database().reference()
        
        if (count == 2)
        {
            handle = ref?.child("test3").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.masterList[2].append(item)
                    self.myTableView.reloadData()
                }
                
                
            })
            
        }
        
        
        self.view.backgroundColor = .orange

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

}
