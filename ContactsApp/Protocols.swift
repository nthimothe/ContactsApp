//
//  Protocols.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/15/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import Foundation
import UIKit

protocol DataReceivable {
    func passData(dataType data: Contact)
    func passBool(selfExists: Bool)
    func passBool(contactWasEdited: Bool)
    func saveAllContacts()
}
extension DataReceivable {
    func passBool(selfExists: Bool) { }
    func passBool(contactWasEdited: Bool) { }
    func saveAllContacts() { }
}

protocol UserEditable {
    func shake(_ view: UIView, repeatCount : Float, duration: TimeInterval, translation : Float)
}


