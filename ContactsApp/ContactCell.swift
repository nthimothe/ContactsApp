//
//  ContactCellTableViewCell.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/13/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            //nameLabel.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1.0)
            //nameLabel.layer.borderWidth = 0.5
            //nameLabel.layer.cornerRadius = 25.0
            nameLabel.font = nameLabel.font.withSize(20)
        }
    }
    @IBOutlet weak var relationshipLabel: UILabel! {
        didSet {
            // shift it 2 down from where it used to be
            //relationshipLabel.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
            //relationshipLabel.layer.borderWidth = 0.5
            //relationshipLabel.layer.cornerRadius = 25.0
            relationshipLabel.font = relationshipLabel.font.withSize(nameLabel.font.pointSize / 1.2)
            relationshipLabel.textColor = UIColor.darkGray
        }
    }
    var isFavorite : Bool?
    @IBOutlet weak var isFavoriteButton: UIButton! {
        didSet {
            //isFavoriteButton.imageView?.layer.cornerRadius =
            //isFavoriteButton.imageView?.layer.masksToBounds = true
            isFavoriteButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    let separator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        return view
    }()
    
    var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25.0
        imageView.layer.masksToBounds = true
        // if the image does not fit the cropped area, it will still appear circular in the profile image
        imageView.backgroundColor = Constants.IMAGE_BACKGROUND_COLOR
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // add profile image view to subview of cell
        addSubview(profileImageView)
        addSubview(separator)
        // set constraints
        
        // sey x,y?
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: -10).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        // width, height
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // separator constraints
        // left, top, width, height
        separator.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 5).isActive = true
        separator.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        // width, height
        separator.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, constant: 5).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // relationshipLabel constraints
        relationshipLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true // starts at name Label
        relationshipLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 2).isActive = true // 2 below separator
        // width, height
        relationshipLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, constant: -10).isActive = true
        relationshipLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: -10).isActive = true
        
        // quick nameLabel constraint
        nameLabel.rightAnchor.constraint(equalTo: isFavoriteButton.leftAnchor, constant: -30).isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    @IBAction func isFavoriteButtonTapped(_ sender: Any){
        isFavorite = !isFavorite!
        isFavorite! ? isFavoriteButton.setImage(UIImage(named: "star_active.png"), for: .normal) : isFavoriteButton.setImage(UIImage(named: "star_inactive.png"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
