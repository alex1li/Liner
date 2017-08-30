//
//  ManagerViewController.swift
//
//
//  Created by Rohan Patel on 8/10/17.
//
//

import FirebaseAuth
import Firebase
import FirebaseDatabase
import UIKit


class ManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    var helloMessage: UILabel!
    var tableView: UITableView!
    var queueName: UITextField!
    var queueWaitTime: UITextField!
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var handle2: DatabaseHandle?
    var popButton: UIButton!
    var addButton: UIButton!
    
    var user = Auth.auth().currentUser
    
    var myList:[String] = []
    var keyList:[String] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = user?.displayName
        
        ref = Database.database().reference()
        
        if(user?.displayName == nil){
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Queue", style: .plain, target: self, action: #selector(createQueue))
            
            createAlert(title: "Hey Manager!", message: "Click Create Queue to create your queue")
            
            
        }
        else {
            
            handles()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAnonymous))
            
            
        }
        
        
        tableView = UITableView(frame: view.frame)
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        
        popButton = UIButton(frame: CGRect(x: 110, y: 500, width: 100, height: 30))
        popButton.setTitle("Pop", for: .normal)
        popButton.setTitleColor(.black, for: .normal)
        popButton.backgroundColor = .white
        popButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        view.addSubview(popButton)
        
        
        // Do any additional setup after loading the view.
    }
    
    func pop() {
        
        
        if(myList.count > 1) {
            print(self.keyList[1])
            self.myList.remove(at: 1)
            self.ref?.child("Queues").child((self.user?.displayName!)!).child(self.keyList[1]).setValue(nil)
            self.keyList.remove(at: 1)
            
            tableView.reloadData()
            
            view.reloadInputViews()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default , reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        cell.textLabel?.text = self.myList[indexPath.row]
        
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
    
    
    func handles() {
        
        handle = ref?.child("Queues").child((user?.displayName)!).observe(.childAdded, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if let item = snapshot.value as! String? {
                self.myList.append(item)
                self.tableView.reloadData()
                
            }
            
            if let item = snapshot.key as! String? {
                self.keyList.append(item)
                
            }
            
        })
        
        handle2 = ref?.child("Queues").child((user?.displayName)!).observe(.childRemoved, with: { (snapshot) in
            //***Adding keys to myList instead of the values now to allow for easy deleting of top person
            if (snapshot.value as! String?) != nil {
                
                if(self.myList.index(of: snapshot.value as! String) != nil) {
                    
                    let index1 = self.keyList.index(of: snapshot.key as! String)
                    self.keyList.remove(at: index1!)
                    self.myList.remove(at: index1!)
                    
                }
                
                self.tableView.reloadData()
            }
            
            
            
        })
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(handle == nil && user?.displayName != nil) {
            
            handles()
            
        }
        if(user?.displayName != nil) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAnonymous))
            
        }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        if(!tableView.isEditing)
        {
            tableView.isEditing = true;
            // self.editButtonItem.title = "Done"
        }
            
        else {
            tableView.isEditing = false;
            // self.editButtonItem.title = "Edit"
            
        }
        
        
    }
    
    func addAnonymous() {
        
        let user = Auth.auth().currentUser
        let currentDateTime = Date()
        ref?.child("Queues").child((user?.displayName)!).child(String(describing: currentDateTime)).setValue("Anonymous")
        tableView.reloadData()
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            self.ref?.child("Queues").child((self.user?.displayName!)!).child(self.keyList[indexPath.row]).setValue(nil)
            tableView.beginUpdates()
            self.myList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
        
        
        return [delete]
        
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

