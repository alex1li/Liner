//
//  ChooseViewController.swift
//  Liner
//
//  Created by Alexander Li on 8/9/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var tableView: UITableView!
    var names: [String]! = []
    var count = 0;
    let searchController = UISearchController(searchResultsController: nil)
    
    var queueList = [String]()
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    var handle2: DatabaseHandle?
    
    var filteredQueues = [String]()
    
    var chosenQueue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "lynn"
        
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.white
        
        ref = Database.database().reference()
        
        handle = ref?.child("Queues").observe(.childAdded, with: { (snapshot) in
            //This initally goes throough all existing data
            let actualQueue = snapshot.key
            self.queueList.append(actualQueue)
            self.filteredQueues.append(actualQueue)
            self.tableView.reloadData()
        })
        
        handle2 = ref?.child("Queues").observe(.childRemoved, with: { (snapshot) in
            //***Adding keys to myList instead of the values now to allow for easy deleting of top person
            if (snapshot.key as String?) != nil {
                self.queueList = self.queueList.filter { $0 != snapshot.key }
                self.filteredQueues = self.filteredQueues.filter { $0 != snapshot.key }
                self.tableView.reloadData()
            }
        })
        
        filteredQueues = queueList
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default , reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        //cell.layer.borderWidth = 2
        //cell.layer.borderColor = UIColor.black.cgColor
        
        
        cell.textLabel?.text = filteredQueues[indexPath.row]
        cell.textLabel?.textAlignment = .center
        //cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)!
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenOne = filteredQueues[indexPath.row]
        chosenQueue = chosenOne
        Queue.chosenQueue = chosenOne
        self.navigationController?.pushViewController( QueueViewController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        //Queue.queueID = chosenOne

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text! == "") {
            filteredQueues = queueList
        }
        else
        {
            filteredQueues = queueList.filter(isMatch)
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
        return self.filteredQueues.count
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
