//
//  Contact.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/13/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import Foundation
import UIKit
import os.log

enum Relationship: String, CaseIterable {
    case myself = "Self"
    case mother = "Mother"
    case father = "Father"
    case brother = "Brother"
    case sister = "Sister"
    case spouse = "Spouse"
    case partner = "Partner"
    case cousin = "Cousin"
    case friend = "Friend"
    case acquaintance = "Acquaintance"
    case stranger = "Stranger"
    case coworker = "Coworker"
    case other = "Other"
}

struct PropertyKey {
    static let firstName : String = "firstName"
    static let lastName : String = "lastName"
    static let primaryPhone : String = "primaryPhone"
    static let secondaryPhone : String = "secondaryPhone"
    static let email : String = "email"
    static let birthday: String = "birthday"
    static let isFavorite : String = "isFavorite"
    static let relationship : String = "relationship"
    static let notes : String = "notes"
    static let contactPhoto : String = "contactPhoto"
}

class Contact : NSObject, NSCoding{
    //MARK: Properties
    var firstName : String?
    var lastName : String?
    var primaryPhone : String?
    var secondaryPhone : String?
    var email : String?
    var birthday: Date?
    var isFavorite : Bool //= false
    // string value since text field needed to carry rawValue as text and it makes more sense to be a String attr
    var relationship : String //= Relationship.stranger.rawValue
    var notes : String?
    var contactPhoto : UIImage? //= UIImage(named: Constants.DEFAULT_IMAGE_NAME)
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contacts")
    
    
    override init() {
        self.firstName = nil
        self.lastName = nil
        self.primaryPhone = nil
        self.secondaryPhone = nil
        self.email = nil
        self.birthday = nil
        self.isFavorite = false
        self.relationship = Relationship.stranger.rawValue
        self.notes = nil
        self.contactPhoto = UIImage(named: Constants.DEFAULT_IMAGE_NAME)
    }
    
    init(firstName: String?, lastName: String?, primaryPhone: String?, secondaryPhone: String?, email: String?, birthday: Date?, isFavorite: Bool, relationship: String, notes: String?, contactPhoto: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        // no checks in init to make sure phone numbers are not over 12 chars
        self.primaryPhone = primaryPhone
        self.secondaryPhone = secondaryPhone
        // no checks in init to make sure email conforms to email REGEX
        self.email = email
        self.birthday = birthday
        self.isFavorite = isFavorite
        // no checks in init to make sure relationship is a rawValue of Relatioship enumeration
        self.relationship = relationship
        self.notes = notes
        self.contactPhoto = contactPhoto
    }
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(self.firstName, forKey: PropertyKey.firstName)
        coder.encode(self.lastName, forKey: PropertyKey.lastName)
        coder.encode(self.primaryPhone, forKey: PropertyKey.primaryPhone)
        coder.encode(self.secondaryPhone, forKey: PropertyKey.secondaryPhone)
        coder.encode(self.email, forKey: PropertyKey.email)
        coder.encode(self.birthday, forKey: PropertyKey.birthday)
        coder.encode(self.isFavorite, forKey: PropertyKey.isFavorite)
        coder.encode(self.relationship, forKey: PropertyKey.relationship)
        coder.encode(self.notes, forKey: PropertyKey.notes)
        coder.encode(self.contactPhoto, forKey: PropertyKey.contactPhoto)
    }
    
    required convenience init?(coder: NSCoder) {
        let firstName = coder.decodeObject(forKey: PropertyKey.firstName) as? String
        let lastName = coder.decodeObject(forKey: PropertyKey.lastName) as? String
        let primaryPhone = coder.decodeObject(forKey: PropertyKey.primaryPhone) as? String
        let secondaryPhone = coder.decodeObject(forKey: PropertyKey.secondaryPhone) as? String
        let email = coder.decodeObject(forKey: PropertyKey.email) as? String
        let birthday = coder.decodeObject(forKey: PropertyKey.birthday) as? Date
        // IGNORE isFavorite is required. If we cannot decode isFavorite, the initializer should fail.
        let isFavorite = coder.decodeBool(forKey: PropertyKey.isFavorite)
        //let isFavorite = coder.decodeObject(forKey: PropertyKey.isFavorite) as? Bool
        // Th is required. If we cannot decode a relationship string, the initializer should fail.
        guard let relationship = coder.decodeObject(forKey: PropertyKey.relationship) as? String else{
            os_log("Unable to decode the relationship property of a Contact object.", log: OSLog.default, type: .debug)
            return nil
        }
        let notes = coder.decodeObject(forKey: PropertyKey.notes) as? String
        // Because contactPhoto is an optional property of Contact, just use conditional cast.
        let contactPhoto = coder.decodeObject(forKey: PropertyKey.contactPhoto) as? UIImage
        // initialize contact object
        self.init(firstName: firstName, lastName: lastName, primaryPhone: primaryPhone, secondaryPhone: secondaryPhone, email: email, birthday: birthday, isFavorite: isFavorite, relationship: relationship, notes: notes, contactPhoto: contactPhoto)
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return (lhs.firstName == rhs.firstName) && (lhs.lastName == rhs.lastName) && (lhs.primaryPhone == rhs.primaryPhone) && (lhs.secondaryPhone == rhs.secondaryPhone) && (lhs.email == rhs.email) && (lhs.birthday == rhs.birthday) && (lhs.isFavorite == rhs.isFavorite) && (lhs.relationship == rhs.relationship) && (lhs.notes == rhs.notes) &&
            (lhs.contactPhoto == rhs.contactPhoto) && (lhs === rhs)
    }
    
    func dump() -> String {
        var buffer : String = "Contact: "
        buffer += "\n\tFirst Name: " + (self.firstName ?? "nil")
        buffer += "\n\tLast Name: " + (self.lastName ?? "nil")
        buffer += "\n\tPrimary Phone Number: " + (self.primaryPhone ?? "nil")
        buffer += "\n\tSecondary Phone Number: " + (self.secondaryPhone ?? "nil")
        buffer += "\n\tEmail: Address: " + (self.email ?? "nil")
        let formatter = DateFormatter()
        formatter.dateStyle = Constants.DATE_STYLE
        buffer += "\n\tBirthday: " + (formatter.string(from: self.birthday ?? Date.distantPast))
        buffer += "\n\tisFavorite: " + (self.isFavorite ? "T" : "F" )
        buffer += "\n\tRelationship: " + (self.relationship )
        buffer += "\n\tNotes: " + (self.notes ?? "nil")
        buffer += "\n\tContact Photo: " + (self.contactPhoto?.debugDescription ?? "nil")
        return buffer
    }
    
    
    
    
}
