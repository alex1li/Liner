//
//  SettingsLauncher.swift
//  Liner
//
//  Created by Alexander Li on 9/9/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    var cellID = "cellID"
    var cellHeight: CGFloat = 50
    var managerViewController: ManagerViewController?
    
    //class settings at bottom of this file
    //Change this array to change the pull out menu------------------
    let settings: [Settings] = {
        return [Settings(name: "Close Queue", imageName: "settings"),
                Settings(name: "Delete Queue", imageName: "settings"),
                Settings(name: "Logout", imageName: "settings"),
                Settings(name: "Dismiss", imageName: "settings")]
    }()
    
    
    var view: UIView
    
    init(view: UIView){
        self.view = view
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    
    func showMenu(){
        //Make background view darker
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMenuDismiss)))
        
        
        view.addSubview(blackView)
        view.addSubview(collectionView)
        
        let height: CGFloat = CGFloat(settings.count)*cellHeight
        collectionView.frame = CGRect(x:0,y:view.frame.height, width:view.frame.width, height: height)
        blackView.frame = view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            
            self.collectionView.frame = CGRect(x:0,y:self.view.frame.height-height, width:self.view.frame.width, height: height)
        }, completion: nil)
        
        
        
    }
    
    func handleMenuDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x:0,y:self.view.frame.height, width:self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SettingsCell
        let currentSetting = settings[indexPath.item]
        cell.settings = currentSetting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x:0,y:self.view.frame.height, width:self.collectionView.frame.width, height: self.collectionView.frame.height)
        }) { (Bool) in
            //let currentSetting = settings[indexPath.item]
            if (indexPath.item == 0){
                self.managerViewController?.close()
            }
            
            else if (indexPath.item == 1){
                self.managerViewController?.deleteQueue()
            }
                
            else if (indexPath.item == 2){
                self.managerViewController?.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    
    
}

class Settings: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
    
}

