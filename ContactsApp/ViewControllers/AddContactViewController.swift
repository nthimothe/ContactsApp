//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/14/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UserEditable{
    
    var relationshipPickerData = Relationship.allCases
    
    var saveButtonTapped : Bool = false
    
    var delegate : DataReceivable? = nil
    
    var contact : Contact = Contact()
    
    var contactWasEdited : Bool = false
    
    var isEditView : Bool = false
    
    /* PROGRAMMATICALLY DEFINING ALL UI ELEMENTS */
    // this block of code is only called when needed
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var scrollingView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .clear
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.translatesAutoresizingMaskIntoConstraints = false
        // why does scrollingView's background color have to match the inputContainerView's background color to allow the screen to be scrollable when this view is presented from the contactViewController?
        view.backgroundColor = .white
        return view
    }()
    
    let saveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitle("Save", for: .normal)
        button.isUserInteractionEnabled = true
        return button
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
        imgView.backgroundColor = .white
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        // imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 50.0
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: Constants.DEFAULT_IMAGE_NAME)
        return imgView
    }()
    
    let addPhotoButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Add a Photo", for: .normal)
        button.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
        return button
    }()
    
    let firstNameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "First Name"
        field.adjustsFontSizeToFitWidth = true
        field.backgroundColor = .white
        field.text = nil
        return field
    }()
    
    let firstLastSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lastNameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Last Name"
        field.adjustsFontSizeToFitWidth = true
        field.backgroundColor = .white
        field.text = nil
        return field
    }()
    
    let lastNamePrimaryPhoneSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let primaryPhoneField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .phonePad
        field.backgroundColor = .white
        field.placeholder = "Primary Phone"
        field.text = nil
        return field
    }()
    
    let primarySecondarySeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondaryPhoneField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .phonePad
        field.backgroundColor = .white
        field.placeholder = "Secondary Phone"
        field.text = nil
        return field
    }()
    
    let secondaryPhoneEmailSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .emailAddress
        field.backgroundColor = .white
        field.adjustsFontSizeToFitWidth = true
        field.autocapitalizationType = .none
        field.placeholder = "Email Address"
        field.text = nil
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
    
    let relationshipField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.placeholder = "Relationship"
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
    
    let birthdayField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.placeholder = "Birthday"
        field.text = nil
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
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.isSelected = false
        button.setImage(UIImage(named: Constants.INACTIVE_STAR)?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    @objc func saveButtonWasPressed() {
        // if contactWasEdited exists, send it to the ContactViewController/TableViewController
        // tell the view controller that is DataReceivable whether the contact has been edited
        // if the add view was called by the table view directly, contactWasEdited must be true
        self.delegate?.passBool(contactWasEdited: self.contactWasEdited)
        
        saveButtonTapped = true
        // set the fields of the contact object that is about to be sent back to either contact or table view controller
        setContactObject()
        // delegate must be set by TableViewController/ContactViewController so we can forcefully unwrap safely
        self.delegate!.passData(dataType: self.contact)
        // once the save button is pressed, contacts are saved!
        // this function will either directly call the table view controllers saveContacts() method or rely on the contactViewController's delegate to then call the tableviewController's saveContacts() method
        self.delegate?.saveAllContacts()
        
        // if the save button is the navigation item button, pop the view controller
        self.navigationController?.popViewController(animated: true)
        // if the save button is not, dismiss the view
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          // define content size of UIScrollView
        // add appropriate subviews
        
        //        let contentWidth = scrollingView.bounds.width
        //        print("Scrolling View Height: \(scrollingView.bounds.height)")
        //        let contentHeight = scrollingView.bounds.height * 6
        //        scrollingView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        
        // set delegates and bring up keyboard for firstNameField
        firstNameField.becomeFirstResponder()
        setDelegates()
        
        // set profileImageView as a UIImagePicker
        profileImageView.isUserInteractionEnabled = true
        
        // configure the rest of the UI Views
        configureViews(self.view.frame.height)
    }
    
    func addTargets() {
    }
    
    
    func configureGeneralTargets(){
        // dismiss keyboard when tapping within UI Scroll View
        scrollingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollingViewWasTapped)))
        
        // allow profile image view to be tapped to trigger image picker view
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
        
        
        // enable save button if firstName is not empty (>0 characters in field) and enforce MAX_LEN for first+last name fields
        firstNameField.addTarget(self, action: #selector(nameFieldDidChange), for: .editingChanged) // ✔️
        lastNameField.addTarget(self, action: #selector(nameFieldDidChange), for: .editingChanged) // ✔️
        
        
        // ensure that email is a valid regex expression + that it doesn't exceed 411 chars
        emailField.addTarget(self, action: #selector(handleEmailCheck), for: .editingDidEnd) // ✔️
        emailField.addTarget(self, action: #selector(emailFieldDidChange), for: .editingChanged)
        
        // allow users to enter 10 digit max phone numbers (US Only right now)
        primaryPhoneField.addTarget(self, action: #selector(phoneNumberFieldDidChange), for: .editingChanged)
        secondaryPhoneField.addTarget(self, action: #selector(phoneNumberFieldDidChange), for: .editingChanged)
        
            
        // ensure that saveButton dismisses view controller
        saveButton.addTarget(self, action: #selector(saveButtonWasPressed), for: .touchUpInside) // ✔️
        isFavoriteButton.addTarget(self, action: #selector(isFavoriteButtonWasPressed), for: .touchUpInside)
    }
    
    @objc func isFavoriteButtonWasPressed(_ sender: UIButton) {
        self.isFavoriteButton.isSelected = !self.isFavoriteButton.isSelected
        let active = UIImage(named: Constants.ACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        let inactive = UIImage(named: Constants.INACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        self.isFavoriteButton.isSelected ? self.isFavoriteButton.setImage(active, for: .normal) : self.isFavoriteButton.setImage(inactive, for: .normal)
    }
    
    func configureNav(){
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonWasPressed)), animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false // automatically disable the save button
        self.saveButton.isHidden = true // hiding button (instead of removing from superview)
    }
    
    func configureEditTargets(){
        // general targets will be created after view did load
        emailField.addTarget(self, action: #selector(ensureEmailChange), for: .editingChanged)
        
        primaryPhoneField.addTarget(self, action: #selector(ensurePhoneNumberChange), for: .editingChanged) // ✔️
        secondaryPhoneField.addTarget(self, action: #selector(ensurePhoneNumberChange), for: .editingChanged) // ✔️
        
        relationshipField.addTarget(self, action: #selector(ensureRelationshipChange), for: .editingDidEnd) // ✔️
        
        birthdayField.addTarget(self, action: #selector(ensureBirthdayChange), for: .editingDidEnd) // ✔️
        isFavoriteButton.addTarget(self, action: #selector(ensureFavoriteChange), for: .touchUpInside)
    }
    
    
    
    @objc func nameFieldDidChange(_ sender: UITextField) {
        if sender.text!.count >= Constants.MAX_NAME_LENGTH {
            shake(sender)
            // splice and exclude last char
            sender.text = String(sender.text![..<sender.text!.index(sender.text!.startIndex, offsetBy: Constants.MAX_NAME_LENGTH)])
        }
        
        print("lastNameField is nil: \(lastNameField.text == nil)")
        print("contact last name is nil: \(contact.lastName == nil)")
        let firstName = contact.firstName
        let lastName = contact.lastName
        // since names can be nil (and UITextFields are not), temporarily change contact's names if necessary
        if contact.firstName == nil { contact.firstName = "" }
        if contact.lastName == nil { contact.lastName = "" }
        // if a difference is detected between the original contact's name in either of the fields and the field is not empty, enable save button
        enableSaveButton(under: ((firstNameField.text != contact.firstName) && !firstNameField.isEmpty) || ((lastNameField.text != contact.lastName) && !lastNameField.isEmpty))
        // enable save button if there is at least one active field (disable if both fields are empty)
        //enableSaveButton(under: !areBothFieldsEmpty)
        
        contact.firstName = firstName
        contact.lastName = lastName
    }
    
    
    @objc func phoneNumberFieldDidChange(_ sender: UITextField) {
        let MAX_LEN = 12
        if sender.text != nil {
            if sender.text!.count != 0 {
                
                let text = sender.text!
                if  text.count % 4 == 0 && text.count < 9 {
                    // remove the character, add a dash and put the char back
                    sender.text?.remove(at: text.index(before: text.endIndex))
                    sender.text?.append("-")
                    sender.text?.append(text.last!)
                }
                if text.last == "-" {
                    // if backspacing on a number and a '-' is next, automatically remove the '-' character
                    sender.text = String(sender.text![..<text.index(text.startIndex, offsetBy: text.count-1)])
                    print("Modified Text: \(sender.text!)")
                }
                // safe to forcefully unwrap sender.text and a last character definitely exists since len > 0
                if sender.text!.count > MAX_LEN { // field will shake on the MAX_LEN +1'th character
                    // shake the sender is user tries to do forbidden action
                    shake(sender)
                    // take a splice of the string to disallow more than 12 characters (10 chars + 2 dashes)
                    sender.text = String(sender.text![..<text.index(text.startIndex, offsetBy: MAX_LEN)])
                }
                if !sender.text!.last!.isNumber  {
                    shake(sender)
                    // take a splice of the string to remove the numeric character
                    sender.text = String(sender.text![..<text.index(text.startIndex, offsetBy: text.index(before: text.endIndex).utf16Offset(in: text))])
                }
            }
        }
    }
    
    
    @objc func ensurePhoneNumberChange() {
        // SAVE BUTTON CHANGES ---
        let primaryPhone = contact.primaryPhone
        let secondaryPhone = contact.secondaryPhone
        // since names can be nil (and UITextFields are not), temporarily change contact's numbers
        if contact.primaryPhone == nil { contact.primaryPhone = "" }
        if contact.secondaryPhone == nil { contact.secondaryPhone = "" }
        // if a difference is detected between the original contact and either of the fields, enable save button
        enableSaveButton(under: (primaryPhoneField.text != self.contact.primaryPhone) ||  (secondaryPhoneField.text != self.contact.secondaryPhone))
        contact.primaryPhone = primaryPhone
        contact.secondaryPhone = secondaryPhone
    }
    
    @objc func ensureEmailChange(_ sender: UITextField) {
        if contact.email == nil {
            enableSaveButton(under: sender.text != "")
        } else{
            enableSaveButton(under: sender.text != contact.email)
        }
    }
    
    @objc func emailFieldDidChange(_ sender: UITextField) {
        if !emailField.text!.isEmpty {
            let email = emailField.text!
            if email.count >= Constants.MAX_EMAIL_LENGTH {
                shake(sender)
                // splice first Constants.MAX_EMAIL_LENGTH characters
                sender.text = String(sender.text![..<email.index(email.startIndex, offsetBy: Constants.MAX_EMAIL_LENGTH)])
            }
        }
    }
    @objc func ensureFavoriteChange(_ sender: UIButton){
        enableSaveButton(under: sender.isSelected != contact.isFavorite)
    }
    
    private func setDelegates() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        primaryPhoneField.delegate = self
        secondaryPhoneField.delegate = self
        emailField.delegate = self
        relationshipField.delegate = self
        relationshipPicker.delegate = self
        birthdayField.delegate = self
        notesField.delegate = self
    }
    
    
    @objc func scrollingViewWasTapped() {
        self.view.endEditing(true)
    }
    
    @objc func handleEmailCheck(_ sender: UITextField)  {
        if !emailField.text!.isEmpty  {
            let email = emailField.text!
            let emailRegex =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            // if the email isn't valid, shake the field, and show animation of background color from red to gray
            if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email){
                shake(sender)
                self.emailField.textColor = .systemRed
                UIView.animate(withDuration: TimeInterval(Constants.ANIMATION_TIME)) {
                    self.emailField.textColor = .black
                }
            }
        }
    }
    

    
    /// This method sets a contact object's attributes from from UITextInput fields and profile image's image. This method will be called by this view controller in order to pass a contact object to either the table view controller (to display in the table) or to the contact view controller (for display).
    func setContactObject() {
        
        // if the first name field is not empty ("" after trimming OR nil), set the contact's firstName attribute
        if !(self.firstNameField.isEmpty) {
            self.contact.firstName = self.firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.contact.firstName = nil
        }

        if !(self.lastNameField.isEmpty) {
            self.contact.lastName = self.lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.contact.lastName = nil
        }

        if !(self.primaryPhoneField.isEmpty) {
            self.contact.primaryPhone  = self.primaryPhoneField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.contact.primaryPhone = nil
        }
        
        if !(self.secondaryPhoneField.isEmpty) {
            self.contact.secondaryPhone = self.secondaryPhoneField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.contact.secondaryPhone = nil
        }
        
        if !(self.emailField.isEmpty) {
            self.contact.email = self.emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.contact.email = nil
        }
        
        if !(self.relationshipField.isEmpty) {
            self.contact.relationship = self.relationshipField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if !(self.birthdayField.isEmpty) {
            let formatter = DateFormatter()
            formatter.dateStyle = Constants.DATE_STYLE
            self.contact.birthday = formatter.date(from: self.birthdayField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            self.contact.birthday = nil
        }
        
        if !(self.notesField.isEmpty) {
            // do not assign the "notes" placeholder text to a contact object
            if self.notesField.textColor != .placeholderTextColor {
                self.contact.notes = self.notesField.text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } else {
            self.contact.notes = nil
        }
        
        self.contact.isFavorite = isFavoriteButton.isSelected
        // set contact photo
        self.contact.contactPhoto = self.profileImageView.image
    }
    
    /// This method sets UITextInput fields and profile image for a given contact. This method will be called by the presenting view controller, contactViewController in order to prepopulate fields.
    func setFields() {
        self.profileImageView.image = self.contact.contactPhoto
        
        if let firstName = self.contact.firstName {
            self.firstNameField.text = firstName
        }
        
        if let lastName = self.contact.lastName {
            self.lastNameField.text = lastName
        }
        
        if let primaryPhone = self.contact.primaryPhone {
            self.primaryPhoneField.text = primaryPhone
        }
        
        if let secondaryPhone = self.contact.secondaryPhone {
            self.secondaryPhoneField.text = secondaryPhone
        }
        
        if let email = self.contact.email {
            self.emailField.text = email
        }
        
        self.relationshipField.text = self.contact.relationship
    
        if let birthday = self.contact.birthday {
            let formatter = DateFormatter()
            formatter.dateStyle = Constants.DATE_STYLE
            self.birthdayField.text = formatter.string(from: birthday)
        }
        
        if let notes = self.contact.notes {
            self.notesField.text = notes
            self.notesField.textColor = .black
        }
        // conform image to button's template
        let active = UIImage(named: Constants.ACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        let inactive = UIImage(named: Constants.INACTIVE_STAR)?.withRenderingMode(.alwaysTemplate)
        if self.contact.isFavorite {
            self.isFavoriteButton.setImage(active, for: .normal)
            self.isFavoriteButton.isSelected = true
        } else {
            self.isFavoriteButton.setImage(inactive, for: .normal)
            self.isFavoriteButton.isSelected = false
        }
    }
    
    
    /// TODO : Figure out why UIAlertController doesn't immediately appear and halt the progaram
    override func viewWillDisappear(_ animated: Bool) {
        print("saveButtonTapped: \(saveButtonTapped)")
        print("saveButtonIsEnabled: \(self.saveButton.isEnabled)")


        // if save button was not tapped && if the textfield contains characters (if save button's enabled)
        // ask the user if they want to save/delete the contact — in the case that the user swipes down on the view without saving first
        if !saveButtonTapped && self.saveButton.isEnabled {
            let alert = UIAlertController(title: "Would you like to save or delete this contact?", message: "", preferredStyle: .actionSheet)
            // if user selects, save, allow the delegate to pass data, else do othing
            let save = UIAlertAction(title: "Save", style: .default) { (action) in
                self.setContactObject()
                // delegate must be set by TableViewController so we can forcefully unwrap
                self.delegate!.passData(dataType: self.contact)
                self.dismiss(animated: true, completion: nil)
                self.delegate?.saveAllContacts()
            }
            let delete = UIAlertAction(title: "Delete", style: .cancel) { (action)  in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.saveAllContacts()
            }
            alert.addAction(save)
            alert.addAction(delete)
            self.present(alert, animated: true)
            // in the case of editing a contact, save button can only be tapped if an edit is made
        }
        // contact.isFavorite =
    }
    
    private func configureViews(_ height : CGFloat){
        let TEXT_FIELD_HEIGHT = CGFloat(35)
        let SEPARATOR_HEIGHT = CGFloat(1)
        let DISTANCE_FROM_SEPARATOR = CGFloat(5)
        let LEFT_OFFSET = CGFloat(15)
        
        self.view.addSubview(scrollingView)
        // use leading trailing (as opposed to left right) anchor b/c it keeps in mind locale
        scrollingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.scrollingView.addSubview(inputsContainerView)
        inputsContainerView.leadingAnchor.constraint(equalTo: self.scrollingView.leadingAnchor).isActive = true // #
        inputsContainerView.topAnchor.constraint(equalTo: self.scrollingView.topAnchor, constant: 15).isActive = true // $$
        inputsContainerView.widthAnchor.constraint(equalTo: self.scrollingView.widthAnchor).isActive = true // #
        inputsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let views : [UIView] = [saveButton, profileImageView, addPhotoButton, firstNameField, firstLastSeparator, lastNameField, lastNamePrimaryPhoneSeparator, primaryPhoneField, primarySecondarySeparator, secondaryPhoneField, secondaryPhoneField, secondaryPhoneEmailSeparator, emailField,emailRelationshipSeparator, relationshipField, relationshipBirthdaySeparator, birthdayField, birthdayNotesSeparator, notesField, isFavoriteButton]
        
        // add necessary subviews to inputsContainer
        for view in views {
            inputsContainerView.addSubview(view)
        }
        
        saveButton.trailingAnchor.constraint(equalTo: self.inputsContainerView.trailingAnchor, constant: -20).isActive = true
        saveButton.topAnchor.constraint(equalTo: self.inputsContainerView.topAnchor, constant: 5).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.inputsContainerView.centerXAnchor, constant: 0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.inputsContainerView.topAnchor, constant: 30).isActive = true
        //profileImageView.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor, constant: -280).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        print(profileImageView)
        
        addPhotoButton.centerXAnchor.constraint(equalTo: self.inputsContainerView.centerXAnchor, constant: 5).isActive = true
        // the add photo button is 3 * as far away as a textfield would be from a separator UIView
        addPhotoButton.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 15).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        isFavoriteButton.centerXAnchor.constraint(equalTo: self.firstNameField.centerXAnchor).isActive = true
        isFavoriteButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 15).isActive = true
        isFavoriteButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        isFavoriteButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        firstNameField.leadingAnchor.constraint(equalTo: self.inputsContainerView.leadingAnchor, constant: LEFT_OFFSET).isActive = true
        firstNameField.topAnchor.constraint(equalTo: self.isFavoriteButton.bottomAnchor, constant: 15).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor, constant: -50).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: TEXT_FIELD_HEIGHT).isActive = true
        
        // all text inputs' left offsets + width anchors are based on firstNameField's left offset and width anchor, respectively
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
        relationshipField.inputView = relationshipPicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        // create space between Cancel and Done Buttons
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleRTypeCancel))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleRTypeDone))
        toolbar.setItems([cancel, flexible, done], animated: true)
        relationshipField.inputAccessoryView = toolbar
    }
    
    @objc func ensureRelationshipChange(_ sender: UITextField) {
        enableSaveButton(under: sender.text != self.contact.relationship)
    }
    
    @objc func handleRTypeCancel() {
        relationshipField.text = ""
        relationshipField.resignFirstResponder()
    }
    
    @objc func handleRTypeDone() {
        // if the field is empty, and the user selects done, the user must have been on the first option, so set it 
        if relationshipField.text!.isEmpty {
            relationshipField.text = relationshipPickerData[0].rawValue
        }
        relationshipField.resignFirstResponder()
    }
    
    
    func configureBirthdayField() {
        birthdayField.inputView = birthdayPicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        // create space between Cancel and Done Buttons
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDateCancel))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDateDone))
        toolbar.setItems([cancel, flexible, done], animated: true)
        birthdayField.inputAccessoryView = toolbar
    }
    
    @objc func ensureBirthdayChange(_ sender : UITextField) {
        let formatter = DateFormatter()
        formatter.dateStyle = Constants.DATE_STYLE
        if self.contact.birthday == nil {
            enableSaveButton(under: sender.text != "")
        } else {
            let text = formatter.string(from: self.contact.birthday!)
            enableSaveButton(under: sender.text !=  text)
        }
    }
    
    @objc func handleDateCancel() {
        birthdayField.text = ""
        birthdayField.resignFirstResponder()
    }
    
    @objc func handleDateDone() {
        let formatter = DateFormatter()
        formatter.dateStyle = Constants.DATE_STYLE
        birthdayField.text = formatter.string(from: birthdayPicker.date)
        birthdayField.resignFirstResponder()
    }

    
    @objc func handleImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImageView.image = image
            // if the image does not fit the cropped area, it will still appear circular in the profile image view
            profileImageView.backgroundColor = Constants.IMAGE_BACKGROUND_COLOR
            if isEditView {
                self.navigationItem.rightBarButtonItem?.isEnabled = (profileImageView.image != self.contact.contactPhoto )
            }
            dismiss(animated: true, completion: nil)
        }
    }
    /// This function enables whichever save button is visible based on the given boolean parameter
    func enableSaveButton(under condition: Bool, isNavButton: Bool = false) {
        self.navigationItem.rightBarButtonItem?.isEnabled = condition
        self.saveButton.isEnabled = condition
        self.contactWasEdited = condition
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relationshipPickerData.count
    }
    
    // the name of each option is the raw value of each case in enum
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return relationshipPickerData[row].rawValue
    }
    
    // once a row is selected, set the relationship field's text
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        relationshipField.text = relationshipPickerData[row].rawValue
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //notesField.adjustFontSize()
        if textView.text!.count >= Constants.MAX_TEXTVIEW_LENGTH {
            shake(textView)
            // splice and exclude last char
            textView.text = String(textView.text![..<textView.text!.index(textView.text!.startIndex, offsetBy: Constants.MAX_TEXTVIEW_LENGTH)])
        }
        if isEditView {
            if self.contact.notes == nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = (textView.text != "")
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = (textView.text != self.contact.notes)
            }
        }
    }
    
    // Upon hitting return, textField shoud resign and go to next field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // define fields
        let fields = [firstNameField, lastNameField, primaryPhoneField, secondaryPhoneField, emailField, relationshipField, birthdayField, notesField]
        // fields is set when view loads, so safe to unwrap forceful
        let length = fields.count
        let nextViewIndex = fields.index(after: (fields.firstIndex(of: textField))!)
        textField.resignFirstResponder()
        // find the field in the array, and make the next element (% len of fields) the first responder
        fields[nextViewIndex % length].becomeFirstResponder()
        return true
    }

    /// If the notesField is tapped, make sure that the user is able to view it clearly
    func textViewDidBeginEditing(_ textView: UITextView) { // self must be delegate to implement this method
        // if user begins editing and the text 'notes' is present, then nullify text and set color to black
        if textView.text == "Notes" {
            textView.textColor = .black
            textView.text = nil
        }
        scrollingView.scrollRectToVisible(CGRect(x: textView.frame.maxX, y: textView.frame.maxY, width: textView.frame.width, height: textView.frame.height), animated: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = .placeholderTextColor
            //textView.font = textView.font?.withSize(CGFloat(24))
        }
    }
    
    
}
