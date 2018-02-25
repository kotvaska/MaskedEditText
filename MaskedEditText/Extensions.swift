//
//  Extensions.swift
//  MaskedEditText
//
//  Created by Anastasia Zolotykh on 29.01.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//

import UIKit

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
    
    func capitalizePhrase() -> String {
        var capitalize = false
        
        return self.map { e -> String in
            if e == " " || e == "-" {
                capitalize = true
            } else if capitalize {
                capitalize = false
                return String(e).capitalizeFirstLetter()
            }
            
            return String(e).lowercased()
            
            }
            .joined()
            .capitalizeFirstLetter()
    }


    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
              let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
              let from = from16.samePosition(in: self),
              let to = to16.samePosition(in: self) else {
            return nil
        }
        return from..<to
    }

}

enum TextMaskType: String {
    
    case none, email, phone, number, fio, uppercase
    
    func getRegex() -> String {
        var regex = "."
        switch self {
        case .fio:
            regex = "[А-ЯЁA-Zа-яёa-z\\s-]"
        case .number:
            regex = "[\\d.-]"
        default:
            ()
        }
        return regex
    }
    
    func updateRegister(for text: String) -> String {
        switch self {
        case .fio:
            return text.capitalizePhrase()
        case .uppercase:
            return text.uppercased()
        default:
            return text
        }
    }
    
}

extension UITextInput {

    func initDoneButtonToKeyboard(title: String, action: Selector?) -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.done, target: self, action: action)

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }

}

extension UITextField {

    func addDoneButtonToKeyboard(title: String = "Done", action: Selector?) {
        self.inputAccessoryView = initDoneButtonToKeyboard(title: title, action: action)
    }

}

extension UITextView {

    func addDoneButtonToKeyboard(title: String = "Done", action: Selector?) {
        self.inputAccessoryView = initDoneButtonToKeyboard(title: title, action: action)
    }

}
