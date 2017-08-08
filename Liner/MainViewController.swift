//
//  MainViewController.swift
//  firebasetest7
//
//  Created by Rohan Patel on 7/22/17.
//  Copyright © 2017 Rohan Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var tableView: UITableView!
    var names: [String]! = []
    var count = 0;
    let searchController = UISearchController(searchResultsController: nil)
    var filterednames:[String]!;

    
    
    override func viewDidLoad() {
        let user = Auth.auth().currentUser

        // ignore
        if(String(describing: user!.displayName) == "ro") {
            self.navigationController?.pushViewController( LoginViewController(), animated: true)
            
        }
        
        
        
        super.viewDidLoad()
        
        self.title = "Lynn"

        initializenames()
        print("Hello World")
        view.backgroundColor = .orange
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        
        let image = UIImage(named: "paris.png")
        let imageView = UIImageView(image: image)
        imageView.alpha = 0.3
        

        tableView.backgroundColor = UIColor(patternImage: image!)
        
        
        // make filterned names everything first
        filterednames = names;
        
        // initiatlize search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        
        // Do any additional setup after loading the view.
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // initialize cells
        let cell = UITableViewCell(style: .default , reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
    
        cell.textLabel?.text = filterednames[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
        
        
    }
    
    func initializenames() {
        names.append("Queue 1")
        names.append("Queue 2")
        names.append("Queue 3")
        names.append("Queue 4")
        names.append("Queue 5")
        names.append("Queue 6")
        names.append("Queue 7")
        names.append("Queue 8")
        names.append("Queue 9")
        names.append("Queue 10")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if you select a queue, push the view controller
        count = indexPath.row
        self.navigationController?.pushViewController( ViewController(), animated: true)
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text! == "") {
            filterednames = names;
        }
        else
        {
            filterednames = names.filter(isMatch)
        }
        self.tableView.reloadData()
    }
    
    
    func isMatch(s: String) -> Bool{
        
        if(s.contains(searchController.searchBar.text!)) {
            return true
        }
        else {
            return false

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterednames.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ignore this is for me
    
    override func viewDidAppear(_ animated: Bool) {
        print(2)
        
        
        let user = Auth.auth().currentUser
        print(user!.displayName)

        if(user?.displayName == "ro") {
            self.navigationController?.pushViewController( LoginViewController(), animated: true)
            
        }
        

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
