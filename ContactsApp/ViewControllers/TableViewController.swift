//
//  ViewController.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/13/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import UIKit
import os.log

class TableViewController: UITableViewController, DataReceivable{
    /// If selfExists gets passed, use it — Allows ContactViewController can tell TableViewController if self no longer exists
    func passBool(selfExists: Bool) {
        self.selfExists = selfExists
    }
    
    /// If contentWasEdited gets passed, use it — Allows ContactViewController can tell TableViewController if cells need to be shifted/edited
    func passBool(contactWasEdited: Bool) {
        self.contactWasEdited = contactWasEdited
    }
    
    func saveAllContacts() {
        saveContacts()
    }
    var contacts = [Contact]()
    
    /// Indicates whether the self (Relationship) exists in the table view or not
    var selfExists : Bool? = nil
    
    var rowSelected : IndexPath?
    
    var contactWasEdited: Bool? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let contacts = loadContacts() {
            self.contacts = contacts
        } else {
            self.contacts = loadSampleContacts()
        }
        
        // when tableView is originally loaded selfExsits
        assignSelfExists()
    }
    private func loadSampleContacts() -> [Contact] {
        // set up dummy contacts
        let a = Contact()
        let formatter = DateFormatter()
        formatter.dateStyle = Constants.DATE_STYLE
        a.firstName = "The"
        a.lastName = "Weeknd"
        a.relationship = Relationship.acquaintance.rawValue
        a.contactPhoto = UIImage(named: Constants.DEFAULT_IMAGE_NAME)
        a.primaryPhone = "686-96"
        a.isFavorite = true
        a.birthday = formatter.date(from: "February 16, 1990")
        a.notes = "XO"

        return [a, Contact(firstName: "Drizzy", lastName: "Drake", primaryPhone: "686-96", secondaryPhone: nil, email: "drizzydrake@gmail.com", birthday: formatter.date(from: "October 24, 1986"), isFavorite: false, relationship: Relationship.other.rawValue, notes: nil, contactPhoto: UIImage(named: Constants.DEFAULT_IMAGE_NAME))]
    }
    private func assignSelfExists() {
        for contact in self.contacts {
            if contact.relationship == Relationship.myself.rawValue {
                self.selfExists = true
                return
            }
        }
        self.selfExists = false
    }
    
//    /// When the view will disappear, save the contacts
//    override func viewWillDisappear(_ animated: Bool) {
//        saveContacts()
//    }
//
    /// If the contact that is being set is self, pin it to the top of the tableView, else, add it to the end. Also reflect any changes made to contact objects that already existed within the table view
    func passData(dataType data: Contact){
        if (contactWasEdited != nil) && contactWasEdited! {
            var indexPath = NSIndexPath(row: self.contacts.count, section: 0) as IndexPath
            // if the contact is self, pin it to the top of the tableview
            if data.relationship == Relationship.myself.rawValue {
                // not ideal b/c contact could be unchanged, and could possible be doing O(n) shift uneccesarily
                if (self.contacts.contains(data)) {
                    indexPath = NSIndexPath(row: rowSelected!.row, section: 0) as IndexPath
                    self.contacts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                }
                indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                self.contacts.insert(data, at: 0)
                self.selfExists = true
            } else {
                // if the data didn't exist and it's not of type self, append it to the end of contacts
                if !self.contacts.contains(data) {
                    self.contacts.append(data)
                } else {
                    // make sure to modify existing cell if necessary
                    // reconfigure cell — rowSelected must have been set if the contactViewController is called, so it is safe to forcefully unwrap
                   
                    configureCell(contact: data, cell: self.tableView.cellForRow(at: rowSelected!) as! ContactCell)  // OR tableView.reloadRows(at: [rowSelected!], with: .none)
                    // contacts are saved in the Edit view controller if an edit occurs
                    // reset contactWasEdited
                    //self.contactWasEdited = nil
                    return // no need to insert rows when editing an existing cell
                }
            }
            self.tableView.insertRows(at: [indexPath], with: .fade)
    
            // reset contactWasEdited
            //self.contactWasEdited = nil
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        print("debug_message here")
//    }
//
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = contextualDeleteAction(indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    /// This function defines the contextual action of deleting a contact (by swiping on a given cell)
    func contextualDeleteAction(_ indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            var message = "Are you sure that you would like to delete your contact"
            let contact = self.contacts[indexPath.row]
            var name = ""
            if contact.firstName != nil {
                name += contact.firstName!
            }
            if contact.lastName != nil {
                // if name has text, make sure to space out the first and last names
                if !name.isEmpty {
                    name += " "
                }
                name += contact.lastName!
            }
            message += " \"\(name)\"?"
            
            let alert = UIAlertController(title: message, message: "", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                // if the user deletes self from the tableView, adjust selfExists var
                if self.contacts[indexPath.row].relationship == Relationship.myself.rawValue {
                    self.selfExists = false
                }
                self.contacts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.saveContacts() // save contacts after a deletion occurs
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true)
          
            completionHandler(true)
        }
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactCell
        let contact = contacts[indexPath.row]
        // config cell
        configureCell(contact: contact, cell: cell)
        return cell
    }
    
    func configureCell(contact: Contact, cell: ContactCell) {
        let SPACE = "      " // for formatting purposes
        let relation = contact.relationship
        
        // if the first name exists, display the first name, space, then last name
        if let fName = contact.firstName {
            cell.nameLabel.text = SPACE  + fName
            if let lastName = contact.lastName {
                cell.nameLabel.text! += " " + lastName
            }
        // if the first name doesn't exist, just display last name
        } else {
            // last name can be forcefully unwrapped since either the first name or last name must be set
            cell.nameLabel.text = SPACE + contact.lastName!
        }

        cell.isFavorite = contact.isFavorite
        cell.relationshipLabel.text = SPACE
        // set the relationshipLabel text by exhausting all different relationships
        switch relation {
        case Relationship.myself.rawValue:
            cell.relationshipLabel.text! += Relationship.myself.rawValue
            break
        case Relationship.acquaintance.rawValue:
            cell.relationshipLabel.text! += Relationship.acquaintance.rawValue
            break
        case Relationship.mother.rawValue:
            cell.relationshipLabel.text! += Relationship.mother.rawValue
            break
        case Relationship.father.rawValue:
            cell.relationshipLabel.text! += Relationship.father.rawValue
            break
        case Relationship.brother.rawValue:
            cell.relationshipLabel.text! += Relationship.brother.rawValue
            break
        case Relationship.sister.rawValue:
            cell.relationshipLabel.text! += Relationship.sister.rawValue
            break
        case Relationship.spouse.rawValue:
            cell.relationshipLabel.text! += Relationship.spouse.rawValue
            break
        case Relationship.partner.rawValue:
            cell.relationshipLabel.text! += Relationship.partner.rawValue
            break
        case Relationship.cousin.rawValue:
            cell.relationshipLabel.text! += Relationship.cousin.rawValue
            break
        case Relationship.friend.rawValue:
            cell.relationshipLabel.text! += Relationship.friend.rawValue
            break
        case Relationship.stranger.rawValue:
            cell.relationshipLabel.text! += Relationship.stranger.rawValue
            break
        case Relationship.coworker.rawValue:
            cell.relationshipLabel.text! += Relationship.coworker.rawValue
            break
        case Relationship.other.rawValue:
            cell.relationshipLabel.text! += Relationship.other.rawValue
            break
        default:
            print("Unrecognized relationship label present")
            break
        }

        if let image = contact.contactPhoto {
            cell.profileImageView.image = image
        }
        // if the contact is a favorite, label it as such with a star
        contact.isFavorite ? cell.isFavoriteButton.setImage(UIImage(named: "star_active.png"), for: .normal) : cell.isFavoriteButton.setImage(UIImage(named: "star_inactive.png"), for: .normal)
        
    }
    /// When the 'add' button is pressed, trigger code in `prepare(for segue: UIStoryboardSegue, sender: Any?)` and then segue
    @IBAction func addWasPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddContact", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactView = ContactViewController()
        print(self.contacts[indexPath.row].dump())
        // ensure that the contactViewController can send the tableViewController data
        contactView.delegate = self
        // pass the current contact to the contactViewController and whether or not self exists
        contactView.contact = self.contacts[indexPath.row]
        contactView.selfExists = self.selfExists
        contactView.contactWasSelf = (self.contacts[indexPath.row].relationship == Relationship.myself.rawValue)
        self.rowSelected = indexPath
        self.show(contactView, sender: self)
    }
    
    func saveContacts() {
        // path to save contacts to
        let path = Contact.ArchiveURL
        do {
            // archive contacts
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.contacts, requiringSecureCoding: false)
            // write data to the path
            try data.write(to: path)
            // log success
            os_log("Contacts successfully saved.", log: .default, type: .debug)
        } catch {
            os_log("Failed to save contacts.", log: .default, type: .debug)
        }
    }

    private func loadContacts() -> [Contact]? {
        // path to load contacts from
        let path = Contact.ArchiveURL
        // load data from NSData
        if let ns_data = NSData(contentsOf: path) {
            //
            do {
                let data = Data(referencing: ns_data)
                if let loadedContacts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Contact] {
                    // log success
                    os_log("Contacts successfully loaded.", log: .default, type: .debug)
                    return loadedContacts
                }
            } catch {
                // log inability to read file
                os_log("(Couldn't read file) Contacts could not be loaded.", log: .default, type: .debug)
                return nil
            }
        }
        // log
        os_log("No contacts to load.", log: .default, type: .debug)
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddContact"{
            let seg = segue.destination as! AddContactViewController
            seg.delegate = self
            // view must have been loaded (selfExists is set in viewDidLoad) so selfExists exists, it's okay to forcefully unwrap
            if selfExists! {
                // remove self as an option from picker, after it originally exists, there can only be one self
                seg.relationshipPickerData = Array(Relationship.allCases[1...])
            }
            seg.configureGeneralTargets() // %%%%
        }
    }

    
}

