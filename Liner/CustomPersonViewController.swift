//
//  CustomPersonViewController.swift
//  Liner
//
//  Created by Rohan Patel on 9/4/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CustomPersonViewController: UIViewController, UITextFieldDelegate {
    
    var Name: UITextField!
    var addButton: UIButton!
    var ref: DatabaseReference!
    var personNameLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        view.backgroundColor = .white
        
        personNameLabel = UILabel(frame: CGRect(x: 30, y: 100, width: view.frame.size.width-60, height: 30))
        personNameLabel.textColor = .black
        personNameLabel.textAlignment = .center
        personNameLabel.text = "add to your queue"
        personNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        view.addSubview(personNameLabel)
        
        Name = UITextField(frame: CGRect(x: 30, y: 150, width: view.frame.size.width-60, height: 40))
        Name.placeholder = "Name"
        Name.backgroundColor = .white
        Name.borderStyle = UITextBorderStyle.roundedRect
        view.addSubview(Name)

        addButton = UIButton(frame: CGRect(x: 50, y: 250, width: view.frame.size.width-100, height: 60))
        addButton.setTitle("add", for: .normal)
        addButton.addTarget(self, action:#selector(add), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(pressDownAdd), for: .touchDown)
        addButton.addTarget(self, action: #selector(pressUpAdd), for: .touchUpOutside)
        
        addButton.layer.cornerRadius = 30
        addButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1).cgColor
        addButton.layer.borderWidth = 1.5
        addButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1), for: .normal)
        addButton.titleLabel!.textAlignment = .center
        view.addSubview(addButton)

        
        
        
        // Do any additional setup after loading the view.
    }
    
    func add() {
        
        addButton.backgroundColor = .white
        
        let user = Auth.auth().currentUser
        let currentDateTime = Date()
        
        ref?.child("Queues").child((user?.displayName)!).child(String(describing: currentDateTime)).setValue(Name.text)
        
                
        self.navigationController?.popViewController(animated: true)

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (Name.text != nil) {
            add()
        }
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func pressUpAdd(_ sender:Any){
        addButton.backgroundColor = .white
    }
    
    func pressDownAdd(_ sender:Any){
        addButton.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
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
