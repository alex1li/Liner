//
//  ManagerViewController.swift
//  
//
//  Created by Rohan Patel on 8/10/17.
//
//

import FirebaseAuth
import Firebase
import UIKit


class ManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    var helloMessage: UILabel!
    var tableView: UITableView!
    var queueName: UITextField!
    var queueWaitTime: UITextField!


    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        let user = Auth.auth().currentUser
        if(user?.displayName == nil){
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Queue", style: .plain, target: self, action: #selector(createQueue))

            createAlert(title: "Hey Manager!", message: "Click Create Queue to create your queue")
        }
        
        
        tableView = UITableView(frame: view.frame)
        
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        
        
        view.backgroundColor = .blue
        
        helloMessage = UILabel(frame: CGRect(x: 50, y: 60, width: 300, height: 50))
        helloMessage.text = "Hello Manager! Click to create queue"
        helloMessage.textColor = .white
        view.addSubview(helloMessage)
        
            queueName = UITextField(frame: CGRect(x: 30, y: 150,width: 340, height: 40))
            queueName.backgroundColor = .white
            view.addSubview(queueName)
            
            queueWaitTime = UITextField(frame: CGRect(x: 30, y: 220,width: 340, height: 40))
            queueWaitTime.isSecureTextEntry = true
            queueWaitTime.backgroundColor = .white
          //  view.addSubview(queueWaitTime)
        
        
    
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default , reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        return cell
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in print("cancelled")}))

        alert.addAction(UIAlertAction(title: "Create Queue",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in self.createQueue()}))
        

        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func createQueue() {
        
        self.navigationController?.pushViewController(ManagerCreateQueueController(), animated: true)
        
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
