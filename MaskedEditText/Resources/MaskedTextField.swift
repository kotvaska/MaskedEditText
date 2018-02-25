//
// Created by Anastasia Zolotykh on 18.10.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import UIKit

class MaskedTextField: UITextField, MaskedEditText, UITextFieldDelegate {

    private var onEndEditingDelegate: Bool {
        get {
            super.superview!.endEditing(true)
            textDidEndEditingCallback?()
            return true
        }
    }

    var textDidEndEditingCallback: (() -> ())?
    var type: TextMaskType = .none {
        didSet {
            initEditText()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDelegate()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        initDelegate()
    }
    
    func initDelegate() {
        self.delegate = self
    }
    
    func initEditText() {
        autocapitalizationType = getAutocapitalizationType()
        keyboardType = getKeyboardType()
        addDoneButtonIfNeeded(action: #selector(self.resignFirstResponder), textInput: self)
        
        if #available(iOS 11, *) {
            smartInsertDeleteType = .no
        }
        
    }
    
    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(language) {
                    return tim
                }
            }
        }
        return super.textInputMode
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return onEndEditingDelegate
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return onEndEditingDelegate
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = matches(for: type.getRegex(), in: string).joined()

        let textFieldText = textField.text ?? ""
        textField.text = type.updateRegister(for: textFieldText.replacingCharacters(in: textFieldText.range(from: range)!, with: text))
        updateTextRange(with: range, text: text, textInput: self)

        return false
    }

}
