//
//  Extensions.swift
//  ContactsApp
//
//  Created by Nathan Thimothe on 1/14/21.
//  Copyright © 2021 Nathan Thimothe. All rights reserved.
//

import Foundation
import UIKit

extension DataReceivable {
    func passBool(selfExists: Bool) { }
    func passBool(wasContactVisiblyEdited: Bool) { }
    func saveAllContacts() { }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
extension UIColor{
    static var veryLightGray : UIColor {
        return UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    static var placeholderTextColor : UIColor {
        return UIColor(displayP3Red: 0.7803921568627451, green: 0.7803921568627451, blue: 0.803921568627451, alpha: 1.0)
    }
}

extension UserEditable {
    // Shake a UIView
    func shake(_ view: UIView, repeatCount : Float = 2, duration: TimeInterval = 0.25, translation : Float = 2.0){
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = repeatCount
        animation.duration = (duration / TimeInterval(animation.repeatCount))
        animation.autoreverses = true
        animation.values = [-translation, translation]
        view.layer.add(animation, forKey: "shake")
    }
}

extension UITextField {
    /// Checks whether a text input's text is empty, if the text is nil, this method treats the field as if it were empty
    var isEmpty : Bool {
        if let text = self.text {
            return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }
}

extension UILabel {
    func setPlaceholderText(_ text: String) {
        self.text = text
        self.textColor = .placeholderTextColor
    }
}

extension UITextView {

    /// Checks whether a text input's text is empty, if the text is nil, this method treats the field as if it were empty
    var isEmpty : Bool {
        if let text = self.text {
            return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }
//    @objc func adjustFontSize(){
//        adjustFontSizeToFitWidth(self.frame.size)
//    }
//    // Manually adjust font size based on how large
//    private func adjustFontSizeToFitWidth(_ frame: CGSize){
//        if self.text.isEmpty { return }
//        // if the text color is gray, there must be text in it ("Notes")
////        if self.textColor == UIColor.placeholderTextColor {
////            self.font = self.font!.withSize(self.font!.pointSize * 2)
////            return
////        }
//        let width = frame.width
//        var expectedSize = self.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
//        while expectedSize.height < frame.height && self.font != nil{
//            self.font = self.font?.withSize(self.font!.pointSize + 1)
//            expectedSize = self.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
//        }
//        while expectedSize.height > frame.height && self.font != nil{
//            self.font = self.font?.withSize(self.font!.pointSize - 1)
//            expectedSize = self.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
//        }
//        //        if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) {
//        //            return;
//        //        }
//        //
//        //        let textViewSize = self.frame.size;
////        let fixedWidth = textViewSize.width;
////        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
////
////
////        var expectFont = self.font
////        if (expectSize.height > textViewSize.height) {
////
////            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
////                expectFont = self.font!.withSize(self.font!.pointSize - 1)
////                self.font = expectFont
////            }
////        }
////        else {
////            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
////                expectFont = self.font
////                self.font = self.font!.withSize(self.font!.pointSize + 1)
////            }
////            self.font = expectFont
////        }
////    }
//    }
}






