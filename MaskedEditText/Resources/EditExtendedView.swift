//
// Created by Anastasia Zolotykh on 19.03.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import Foundation
import UIKit

class EditExtendedView: NibLoadingView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var editTextView: MaskedTextView!
    @IBOutlet weak var separator: UIView!

    override func nibSetup(nibName: String?) {
        super.nibSetup(nibName: nibName)

        editTextView.layer.borderColor = UIColor(red: 194 / 255.0, green: 194 / 255.0, blue: 194 / 255.0, alpha: 1.0).cgColor
        editTextView.layer.borderWidth = 1.0
        editTextView.layer.cornerRadius = 5.0

    }

    func create(with type: TextMaskType = .none, isMultiLine: Bool = true) -> Self {
        title.text = type.rawValue
        editTextView.type = type
        editTextView.multiLine = isMultiLine
        return self
    }

}
