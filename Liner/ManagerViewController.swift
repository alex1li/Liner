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
    var queueNameLabel: UILabel!
    var gradientView: UIView!
    
    
    var ref: DatabaseReference!
    
    var handle: DatabaseHandle!
    var handle2: DatabaseHandle?
    var handle3: DatabaseHandle?
    
    var popButton: UIButton!
    var popButtonHeight: CGFloat = 70
    var addButton: UIButton!
    
    
    var myList:[String] = []
    var keyList:[String] = []
    var changeRequest: UserProfileChangeRequest?

    
    var user = Auth.auth().currentUser
    
    //Menu class
    var settingsLauncher: SettingsLauncher!



    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.title = "Liner"
        
        ref = Database.database().reference()
        print("display name")
        print(user?.displayName)
        if(user?.displayName == nil || user?.displayName == ""){
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Queue", style: .plain, target: self, action: #selector(createQueue))

            createAlert(title: "Hey Manager!", message: "Click Create Queue to create your queue")
        }
        else {

            handles()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addSomeone))
        }
        let navHeight = navigationController?.navigationBar.frame.size.height
        let tableViewFrame = CGRect(x: 0, y: navHeight!, width: view.frame.width, height: view.frame.height-popButtonHeight-navHeight!)
        tableView = UITableView(frame: tableViewFrame)
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        
        queueNameLabel = UILabel()
        queueNameLabel.frame = CGRect(x: 0, y: navHeight!+30, width: view.frame.width, height: navHeight!)
        queueNameLabel.textAlignment = .center
        queueNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        queueNameLabel.lineBreakMode = .byWordWrapping
        queueNameLabel.numberOfLines = 0;
        if (user?.displayName != nil && user?.displayName != ""){
            queueNameLabel.text = (user?.displayName)!
        }
        else {
            queueNameLabel.text = "no queue"
        }
        queueNameLabel.backgroundColor = .white
        queueNameLabel.textColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        self.view.addSubview(queueNameLabel)
 
        
        gradientView = UIView(frame: CGRect(x: 0, y: view.frame.height-popButtonHeight-10-70, width: view.frame.width, height: 100))
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0).cgColor, UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1).cgColor]
        gradient.locations = [0.0,1.0]
        gradientView.layer.insertSublayer(gradient, at: 0)
        view.addSubview(gradientView)
        
        
        
        popButton = UIButton(frame: CGRect(x: 10, y: view.frame.height-popButtonHeight-10, width: view.frame.width-20-80, height: popButtonHeight))
        popButton.setTitle("Pop", for: .normal)
        popButton.backgroundColor = .white
        popButton.addTarget(self, action: #selector(handlePop), for: .touchUpInside)
        popButton.setTitleColor(UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
        popButton.layer.cornerRadius = 30
        popButton.layer.borderColor = UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        popButton.layer.borderWidth = 1.5
        popButton.addTarget(self, action:#selector(pressUpPop), for: .touchUpOutside)
        popButton.addTarget(self, action:#selector(pressDownPop), for: .touchDown)
        view.addSubview(popButton)
        
        addButton = UIButton(frame: CGRect(x: view.frame.width-20-80+10, y: view.frame.height-popButtonHeight-10, width: 80, height: popButtonHeight))
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .white
        addButton.addTarget(self, action: #selector(addSomeone), for: .touchUpInside)
        addButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1), for: .normal)
        addButton.layer.cornerRadius = 30
        addButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1).cgColor
        addButton.layer.borderWidth = 1.5
        addButton.addTarget(self, action:#selector(pressUpAdd), for: .touchUpOutside)
        addButton.addTarget(self, action:#selector(pressDownAdd), for: .touchDown)
        view.addSubview(addButton)
        
        
        //Setup Navigation Menu Button
        settingsLauncher = SettingsLauncher(view: view)
        setupMenuButton()
        
        print("View Load complete")
        // Do any additional setup after loading the view.
    }
    
    func close() {
        
        if (user?.displayName != nil && user?.displayName != ""){
            ref?.child("QueueInfo").child((user?.displayName)!).child("OpenStatus").setValue("Closed")
            settingsLauncher.changeToClose()
        }
        
    }
    
    func open() {
        
        if (user?.displayName != nil && user?.displayName != ""){
            ref?.child("QueueInfo").child((user?.displayName)!).child("OpenStatus").setValue("Open")
            settingsLauncher.changeToOpen()
        }
        
    }
    
    
    
    
    func handlePop() {
        popButton.backgroundColor = .white
        if(myList.count > 1) {
            print(keyList[1])
            ref?.child("Queues").child((self.user?.displayName!)!).child(self.keyList[1]).setValue(nil)
            tableView.reloadData()
            view.reloadInputViews()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .default , reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        cell.textLabel?.text = myList[indexPath.row]
        
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
    
    func deleteQueue(){
        if (user?.displayName == nil || user?.displayName == ""){
            // create the alert
            let alert = UIAlertController(title: "Error", message: "You have no queue to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            // return
        }
        else{
            ref.child("Queues").child((self.user?.displayName!)!).removeAllObservers()
            print("1")
            ref.child("Queues").child((self.user?.displayName!)!).removeValue()
            print("2")
            ref.child("QueueInfo").child((self.user?.displayName!)!).removeAllObservers()
            print("3")
            ref.child("QueueInfo").child((self.user?.displayName!)!).removeValue()
            
            print("children removed")
            changeRequest = (user?.createProfileChangeRequest())!
            changeRequest?.displayName = ""
            changeRequest?.commitChanges(completion: { (error) in})
            
            while(user?.displayName != ""){
            }
            print("user display name deleted")
            
            myList.removeAll()
            keyList.removeAll()
            tableView.reloadData()
            
            queueNameLabel.text = "no queue"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Queue", style: .plain, target: self, action: #selector(createQueue))
        }
        
        
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
                
                if let indexRemoved = self.myList.index(of: snapshot.value as! String) {
                    print("found removed in myList")
                    //let index1 = self.keyList.index(of: snapshot.key as! String)
                    self.keyList.remove(at: indexRemoved)
                    self.myList.remove(at: indexRemoved)
            
                }
                
                self.tableView.reloadData()
            }
            
        })
        
        handle3 = ref?.child("QueueInfo").child((user?.displayName)!).observe(.childAdded, with: { (snapshot) in
            //Adding keys to myList instead of the values now to allow for easy deleting of top person
            if let item = snapshot.value as! String? {
                
                if(item == "Closed") {
                    self.settingsLauncher.changeToClose()
                    
                }
                
                
            }
        })
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if(handle == nil){
            if (user?.displayName == nil || user?.displayName == "") {
                print("no queue associated")
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Queue", style: .plain, target: self, action: #selector(createQueue))
                queueNameLabel.text = "no queue"
            }
            else{
                self.handles()
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addSomeone))
                queueNameLabel.text = (user?.displayName)!
            }
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
    
    func addSomeone() {
        //let user = Auth.auth().currentUser
        //let currentDateTime = Date()
        addButton.backgroundColor = .white
        self.navigationController?.pushViewController(CustomPersonViewController(), animated: true)
        tableView.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            if(indexPath.row == 0) {
                return
            }
            
            
        self.ref?.child("Queues").child((self.user?.displayName!)!).child(self.keyList[indexPath.row]).setValue(nil)
            tableView.beginUpdates()
            self.myList.remove(at: indexPath.row)
            self.keyList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()

        }
    
        
        return [delete]

    }
    
    //MARK: MENU BAR
    
    func setupMenuButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleMenuButtonPressed))
    }
    
    func handleMenuButtonPressed(){
        settingsLauncher.managerViewController = self
        settingsLauncher.showMenu()
    }
    
    //MARK: Button presses
    
    func pressUpPop(_ sender:Any){
        popButton.backgroundColor = .white
    }
    
    func pressDownPop(_ sender:Any){
        popButton.backgroundColor = UIColor(colorLiteralRed: 200/255, green: 50/255, blue: 50/255, alpha: 1)
    }
    
    func pressUpAdd(_ sender:Any){
        addButton.backgroundColor = .white
    }
    
    func pressDownAdd(_ sender:Any){
        addButton.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 200/255, blue: 50/255, alpha: 1)
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
