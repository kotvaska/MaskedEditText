//
// Created by Anastasia Zolotykh on 19.03.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import Foundation
import UIKit

class EditNormalView: NibLoadingView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var editTextField: MaskedTextField!
    @IBOutlet weak var separator: UIView!

    func create(with type: TextMaskType) -> Self {
        title.text = type.rawValue
        editTextField.type = type
        return self
    }

}
