//
//  MaskedEditText.swift
//  MaskedEditText
//
//  Created by Anastasia Zolotykh on 29.01.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//

import UIKit

protocol MaskedEditText {

    var type: TextMaskType { get set }

    func initDelegate()

    func initEditText()

    func addDoneButtonToKeyboard(title: String, action: Selector?)

}

extension MaskedEditText {

    func addDoneButtonIfNeeded(title: String = "Done", action: Selector?, textInput: UITextInput) {
        if textInput.keyboardType == .phonePad || textInput.keyboardType == .numberPad || textInput.keyboardType == .decimalPad {
            addDoneButtonToKeyboard(title: title, action: action)
        }
    }

    func updateTextRange(with range: _NSRange, text: String, textInput: UITextInput) {
        let length = text.count
        var position = 0
        if text.isEmpty {
            position = range.location
        } else {
            if (range.length <= length) {
                position = range.location + length
            } else {
                position = range.location - length + range.length
            }
        }
        let textRange = NSMakeRange(position, 0)

        if let start = textInput.position(from: textInput.beginningOfDocument, offset: textRange.location),
           let end = textInput.position(from: start, offset: textRange.length) {
            textInput.selectedTextRange = textInput.textRange(from: start, to: end)
        }
    }

    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                    range: NSRange(text.startIndex..., in: text))

            return results.map { e -> String in
                if let range = Range(e.range, in: text) {
                    return String(text[range])
                } else {
                    return ""
                }
            }

        } catch {
            return []

        }
    }

    func getKeyboardLanguage() -> String? {
        switch type {
        case .fio:
            return "ru"
        default:
            return nil
        }
    }

    func getAutocapitalizationType() -> UITextAutocapitalizationType {
        switch type {
        case .uppercase:
            return .allCharacters
        case .fio:
            return .words
        default:
            return .none
        }
    }

    func getKeyboardType() -> UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        case .number:
            return .numberPad
        default:
            return .default
        }
    }

}
