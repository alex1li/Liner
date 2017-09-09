//
//  SettingsCell.swift
//  Liner
//
//  Created by Alexander Li on 9/9/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell{
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    //Instructions for this part
    //https://www.youtube.com/watch?v=PNmuTTd5zWc
    var settings: Settings? {
        didSet {
            nameLabel.text = settings?.name
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .white
        
        addSubview(nameLabel)
        
        //Constraints for the nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: nameLabel.superview!.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: nameLabel.superview!.centerYAnchor).isActive = true
        
        //Add constraints later
    }
}
