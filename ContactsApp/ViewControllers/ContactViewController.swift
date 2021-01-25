//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/14/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UINavigationControllerDelegate, UserEditable, DataReceivable{
    
        
    // update contact object and set fields with new text when data is passed from addContactViewController
    func passData(dataType data: Contact) {
        self.contact = data
        setFields()
    }
    func passBool(contactWasEdited: Bool) {
        self.contactWasEdited = contactWasEdited
    }
    
    func saveAllContacts() {
        self.delegate?.saveAllContacts()
    }
    var relationshipPickerData = Relationship.allCases

    var delegate : DataReceivable? = nil

    var contact : Contact = Contact()
    
    var contactWasSelf : Bool? = nil
    
    var contactWasEdited : Bool?

    var selfExists : Bool? = nil

    /* PROGRAMMATICALLY DEFINING ALL UI ELEMENTS */
    // this block of code is only called when needed
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var scrollingView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .clear
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        // imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 50.0
        imgView.contentMode = .scaleAspectFit
        // image will be set by the tableview controller when it passes the contact object
        return imgView
    }()


    let firstNameField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.backgroundColor = .white
        field.setPlaceholderText("First Name")
        return field
    }()

    let firstLastSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let lastNameField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.backgroundColor = .white
        field.setPlaceholderText("Last Name")
        return field
    }()

    let lastNamePrimaryPhoneSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let primaryPhoneField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.setPlaceholderText("Primary Phone")
        // allow user to interact with phone label (to make a call)
        field.isUserInteractionEnabled = true
        return field
    }()

    let primarySecondarySeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let secondaryPhoneField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.setPlaceholderText("Secondary Phone")
        field.isUserInteractionEnabled = true
        return field
    }()

    let secondaryPhoneEmailSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let emailField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.adjustsFontSizeToFitWidth = true
        field.setPlaceholderText("Email Address")
        // allow user to interact with email label (to send an email)
        field.isUserInteractionEnabled = true
        return field
    }()

    let emailRelationshipSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let relationshipPicker : UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    let relationshipField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.setPlaceholderText("Relationship")
        return field
    }()

    let relationshipBirthdaySeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let birthdayPicker : UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        picker.datePickerMode = UIDatePicker.Mode.date
        return picker
    }()

    let birthdayField : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.setPlaceholderText("Birthday")
        return field
    }()

    let birthdayNotesSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let notesField : UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.layer.borderColor = UIColor.veryLightGray.cgColor
        field.layer.borderWidth = 1.0
        field.isEditable = false
        // automatically set Notes placeholder text
        field.text = "Notes"
        field.textColor = .placeholderTextColor
        field.font = field.font?.withSize(CGFloat(Constants.NOTES_FIELD_TEXT_SIZE))
        return field
    }()
    
    let isFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemBlue
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton : UIButton = {
            let button = UIButton()
            button.setTitle("Contacts", for: .normal)
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
            return button
        }()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditAction)), animated: true)
        addTargets()
        // configure the rest of the UI Views
        configureViews(self.view.frame.height)
        setFields()
    }
        /// Transition from ContactViewController -> TableViewController (send updated contact object)
    @objc func handleBackAction() {
        self.navigationController?.popViewController(animated: true)
        // tell the tableview controller that the contact was edited before it has to decide what to do with it
        if let edited = self.contactWasEdited {
            delegate?.passBool(contactWasEdited: edited)
        } else {
            // if contactWasEdited was not set by AddContactViewController, contact has not yet been edited
            delegate?.passBool(contactWasEdited: false)
        }
        // contact will have been updated by the addContact view controller
        delegate!.passData(dataType: contact)
        
        // if contactWasSelf, but the data (that was recevied from aVC) has a relationship is no longer self, then selfExists is now false
        delegate?.passBool(selfExists: !(contactWasSelf! && (self.contact.relationship != Relationship.myself.rawValue)))
        
    }
    /// Transition from ContactViewController -> AddContactViewController (to allow for editing)
    @objc func handleEditAction() {
        let addContactView = AddContactViewController()
        addContactView.delegate = self
        addContactView.contact = contact
        // if the current contact is not Self, only remove self as an option if it already existed in tableView
        if contact.relationship != Relationship.myself.rawValue && self.selfExists! {
            addContactView.relationshipPickerData = Array(Relationship.allCases[1...])
        }
        self.show(addContactView, sender: self)
        addContactView.configureNav()
        // configure general targets before edit targets to ensure that no forbidden characters are entered
        addContactView.configureGeneralTargets() // %%%%
        addContactView.configureEditTargets()
       
        addContactView.isEditView = true
        addContactView.setFields()
    }
    
    private func setDelegates() {
    }
    
    private func addTargets() {
        primaryPhoneField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptPrimaryCall(_:))))
        secondaryPhoneField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptSecondaryCall(_:))))
        emailField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptEmail)))
    }
    
    /// Prompt the user to call the contact's primary phone number
    @objc func promptPrimaryCall(_ sender : UITapGestureRecognizer){
       var number = primaryPhoneField.text!
        number.removeAll(where: { (c) -> Bool in
            return !c.isNumber
        })
        if number.isEmpty { return }
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /// Prompt the user to call the contact's secondary phone number
    @objc func promptSecondaryCall(_ sender : UITapGestureRecognizer){
        var number = secondaryPhoneField.text!
        number.removeAll(where: { (c) -> Bool in
            return !c.isNumber
        })
        if number.isEmpty { return }
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /// Prompt the user to call the contact's email address
    @objc func promptEmail(_ sender : UITapGestureRecognizer) {
        if emailField.text != "Email Address" {
            if let url = URL(string: "mailto:\(emailField.text!)") {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : (Any).self], completionHandler: nil)
            }
        }
        
    }
    @objc func scrollingViewWasTapped() {
    }

    @objc func handleEmailCheck(_ sender: UITextField)  {
    }

    @objc func handleEmailTextChange(_ sender: UITextField) {
    }

    @objc func handlePhoneNumberChange(_ sender: UITextField) {
    }
    

    /// This method sets UITextInput fields and profile image for a given contact. This method will be called by the presenting view controller, addContactViewController in order to populate fields.
    func setFields() {
        print(self.contact.dump())
        
        // set the image and the background color
        self.profileImageView.image = self.contact.contactPhoto
        if self.profileImageView.image != UIImage(named: Constants.DEFAULT_IMAGE_NAME) {
            self.profileImageView.backgroundColor = Constants.IMAGE_BACKGROUND_COLOR
        }
        // necessary to reset placeholder text, because if not old contact object's fields will
        // still show after having dismissed the edit view
        if let firstName = self.contact.firstName {
            self.firstNameField.text = firstName
            self.firstNameField.textColor = .black
        } else {
            self.firstNameField.setPlaceholderText("First Name")
        }
        
        if let lastName = self.contact.lastName {
            self.lastNameField.text = lastName
            self.lastNameField.textColor = .black
        } else {
            self.lastNameField.setPlaceholderText("Last Name")
        }
        
        if let primaryPhone = self.contact.primaryPhone {
            self.primaryPhoneField.text = primaryPhone
            self.primaryPhoneField.textColor = .systemBlue
        } else {
            self.primaryPhoneField.setPlaceholderText("Primary Phone")
        }
        
        if let secondaryPhone = self.contact.secondaryPhone {
            self.secondaryPhoneField.text = secondaryPhone
            self.secondaryPhoneField.textColor = .systemBlue
        } else {
            self.secondaryPhoneField.setPlaceholderText("Secondary Phone")
        }
        
        self.relationshipField.text = self.contact.relationship
        self.relationshipField.textColor = .black

        if let email = self.contact.email {
            self.emailField.text = email
            self.emailField.textColor = .systemBlue
        } else {
            self.emailField.setPlaceholderText("Email Address")
        }
        
        if let birthday = self.contact.birthday {
            let formatter = DateFormatter()
            formatter.dateStyle = Constants.DATE_STYLE
            self.birthdayField.text = formatter.string(from: birthday)
            self.birthdayField.textColor = .black
        } else {
            self.birthdayField.setPlaceholderText("Birthday")
        }
        
        if let notes = self.contact.notes {
            self.notesField.text = notes
            self.notesField.textColor = .black
            // Adjust the size of the text within the notes field every time the contact view controller shows up if there are notes
            //notesField.adjustFontSize()
        } else {
            notesField.text = "Notes"
            notesField.textColor = .placeholderTextColor
        }

        // conform image to button's template
        let active = UIImage(named: Constants.ACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        let inactive = UIImage(named: Constants.INACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        self.contact.isFavorite ? self.isFavoriteButton.setImage(active, for: .normal) : self.isFavoriteButton.setImage(inactive, for: .normal)
    }
    
    private func configureViews(_ height : CGFloat){
        let TEXT_FIELD_HEIGHT = CGFloat(35)
        let SEPARATOR_HEIGHT = CGFloat(1)
        let DISTANCE_FROM_SEPARATOR = CGFloat(5)
        let LEFT_OFFSET = CGFloat(15)

        scrollingView.backgroundColor = .white
        self.view.addSubview(scrollingView)
        // use leading trailing (as opposed to left right) anchor b/c it keeps in mind locale
        scrollingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        self.scrollingView.addSubview(inputsContainerView)
        inputsContainerView.leadingAnchor.constraint(equalTo: self.scrollingView.leadingAnchor).isActive = true // #
        inputsContainerView.topAnchor.constraint(equalTo: self.scrollingView.topAnchor, constant: 15).isActive = true // $$
        inputsContainerView.widthAnchor.constraint(equalTo: self.scrollingView.widthAnchor).isActive = true // #
        inputsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true

        let views : [UIView] = [profileImageView, firstNameField, firstLastSeparator, lastNameField, lastNamePrimaryPhoneSeparator, primaryPhoneField, primarySecondarySeparator, secondaryPhoneField, secondaryPhoneField, secondaryPhoneEmailSeparator, emailField,emailRelationshipSeparator, relationshipField, relationshipBirthdaySeparator, birthdayField, birthdayNotesSeparator, notesField, isFavoriteButton]

        // add necessary subviews to inputsContainer
        for view in views {
            inputsContainerView.addSubview(view)
        }

        profileImageView.centerXAnchor.constraint(equalTo: self.inputsContainerView.centerXAnchor, constant: 0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.inputsContainerView.topAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true

//        isFavoriteButton.leadingAnchor.constraint(equalTo: self.inputsContainerView.leadingAnchor, constant: LEFT_OFFSET).isActive = true
        isFavoriteButton.centerXAnchor.constraint(equalTo: self.profileImageView.centerXAnchor, constant: 0).isActive = true
        isFavoriteButton.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 15).isActive = true
        isFavoriteButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        isFavoriteButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        firstNameField.leadingAnchor.constraint(equalTo: self.inputsContainerView.leadingAnchor, constant: LEFT_OFFSET).isActive = true
        firstNameField.topAnchor.constraint(equalTo: self.isFavoriteButton.bottomAnchor, constant: 15).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor, constant: -50).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true

        // all text fields' left offsets + width anchors are based on firstNameField's left offset and width anchor, respectively
        for i in 2..<views.count-1 {
            let view = views[i]
            view.leadingAnchor.constraint(equalTo: self.firstNameField.leadingAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.firstNameField.widthAnchor).isActive = true
        }

        firstLastSeparator.topAnchor.constraint(equalTo: self.firstNameField.bottomAnchor, constant: 1).isActive = true
        firstLastSeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true


        lastNameField.topAnchor.constraint(equalTo: self.firstLastSeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true


        lastNamePrimaryPhoneSeparator.topAnchor.constraint(equalTo: self.lastNameField.bottomAnchor, constant: 1).isActive = true
        lastNamePrimaryPhoneSeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true


        primaryPhoneField.topAnchor.constraint(equalTo: self.lastNamePrimaryPhoneSeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        primaryPhoneField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true


        primarySecondarySeparator.topAnchor.constraint(equalTo: self.primaryPhoneField.bottomAnchor, constant: 1).isActive = true
        primarySecondarySeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true


        secondaryPhoneField.topAnchor.constraint(equalTo: self.primarySecondarySeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        secondaryPhoneField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true

        secondaryPhoneEmailSeparator.topAnchor.constraint(equalTo: self.secondaryPhoneField.bottomAnchor, constant: 1).isActive = true
        secondaryPhoneEmailSeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true

        emailField.topAnchor.constraint(equalTo: self.secondaryPhoneEmailSeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true

        emailRelationshipSeparator.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 1).isActive = true
        emailRelationshipSeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true

        configureRelationshipField()
        relationshipField.topAnchor.constraint(equalTo: self.emailRelationshipSeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        relationshipField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true

        relationshipBirthdaySeparator.topAnchor.constraint(equalTo: relationshipField.bottomAnchor, constant: 1).isActive = true
        relationshipBirthdaySeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true

        configureBirthdayField()
        if #available(iOS 14, *) {
            birthdayPicker.preferredDatePickerStyle = .wheels
        }
        birthdayField.topAnchor.constraint(equalTo: relationshipBirthdaySeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        birthdayField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true

        birthdayNotesSeparator.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: 1).isActive = true
        birthdayNotesSeparator.heightAnchor.constraint(equalToConstant: SEPARATOR_HEIGHT).isActive = true

        notesField.topAnchor.constraint(equalTo: birthdayNotesSeparator.bottomAnchor, constant: DISTANCE_FROM_SEPARATOR).isActive = true
        notesField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT * 5).isActive = true

        
    }

    func configureRelationshipField() {
    }

    @objc func handleRTypeCancel() {
    }

    @objc func handleRTypeDone() {
    }


    func configureBirthdayField() {
    }

    @objc func handleDateCancel() {
    }

    @objc func handleDateDone() {
    }

    @objc func handleNameTextChange(_ sender: UITextField) {
    }


    @objc func handleImagePicker() {
    }


}
