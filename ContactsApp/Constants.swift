//
//  Constants.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/15/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let IMAGE_BACKGROUND_COLOR = UIColor.veryLightGray
    static let MAX_NAME_LENGTH = 50 // for both first + last, US name averages — (fName 6 char, 5-7 last name)
    static let MAX_EMAIL_LENGTH = 411 // longest email is held by Zachary and it is 411 char long
    static let ANIMATION_TIME = 3.0
    static let DEFAULT_IMAGE_NAME = "person.png"
    static let DATE_STYLE : DateFormatter.Style = .long
    static let MAX_TEXTVIEW_LENGTH = 525
    static let NOTES_FIELD_TEXT_SIZE = 18.0
    static let ACTIVE_STAR = "star_active.png"
    static let INACTIVE_STAR = "star_inactive.png"
}
