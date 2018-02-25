//
// Created by Anastasia Zolotykh on 12.01.2018.
// Copyright (c) 2018 chedev. All rights reserved.
//

import UIKit
import Anchorage

@IBDesignable
class MaskedTextView: UITextView, MaskedEditText, UITextViewDelegate {

    @IBInspectable var multiLine = true

    private let placeholderColor: UIColor = UIColor(white: 0.78, alpha: 1)
    private var placeholderLabel: UILabel!

    private var shouldIgnorePredictiveInput = false

    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    override var text: String! {
        didSet {
            textViewDidChange(self)
        }
    }

    private var onEndEditingDelegate: Bool {
        get {
            super.superview?.endEditing(true)
            textDidEndEditingCallback?()
            return true
        }
    }

    var textDidEndEditingCallback: (() -> Bool)?
    var type: TextMaskType = .none {
        didSet {
            initEditText()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDelegate()
        configurePlaceholderLabel()
    }

    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initDelegate()
        configurePlaceholderLabel()
    }

    func initDelegate() {
        self.delegate = self
    }

    private func configurePlaceholderLabel() {
        placeholderLabel = UILabel()
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 1
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(placeholderLabel)
        self.sendSubview(toBack: placeholderLabel)

        placeholderLabel.widthAnchor == self.widthAnchor + 2
        placeholderLabel.centerAnchors == self.centerAnchors
        placeholderLabel.verticalAnchors == self.verticalAnchors
        placeholderLabel.horizontalAnchors == self.horizontalAnchors + 4

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

    // MARK: - UITextViewDelegate

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return onEndEditingDelegate
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: textView.font?.lineHeight ?? 1))
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if shouldIgnorePredictiveInput {
            shouldIgnorePredictiveInput = false
            return false
        }

        shouldIgnorePredictiveInput = true

        if text != text.trimmingCharacters(in: .newlines) {
            if !multiLine {
                textView.resignFirstResponder()
                return false
            } else {
                return true
            }
        }

        let string = matches(for: type.getRegex(), in: text).joined()

        let textViewText = textView.text ?? ""
        textView.text = type.updateRegister(for: textViewText.replacingCharacters(in: textViewText.range(from: range)!, with: string))
        updateTextRange(with: range, text: string, textInput: self)

        shouldIgnorePredictiveInput = false

        return false
    }

}
