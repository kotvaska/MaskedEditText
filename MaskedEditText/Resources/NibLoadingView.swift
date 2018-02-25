//
// Created by Anastasia Zolotykh on 19.03.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import UIKit

// Usage: Subclass your UIView from NibLoadView to automatically load a xib with the same name as your class

@IBDesignable
class NibLoadingView: UIView {

    @IBOutlet weak var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    func nibSetup(nibName: String? = nil) {
        backgroundColor = .clear

        view = loadViewFromNib(nibName: nibName == nil ? String(describing: type(of: self)) : nibName!)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
    }

    private func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }

}
