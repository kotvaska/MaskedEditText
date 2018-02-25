//
//  ViewController.swift
//  MaskedEditText
//
//  Created by Anastasia Zolotykh on 29.01.2018.
//  Copyright © 2018 kotvaska. All rights reserved.
//

import UIKit
import Anchorage

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        var views = [UIView]()

        views.append(EditExtendedView().create(with: .number))
        views.append(EditExtendedView().create(with: .email))
        views.append(EditExtendedView().create(with: .uppercase))
        views.append(EditExtendedView().create(with: .phone))
        views.append(EditExtendedView().create(with: .fio))
        views.append(EditNormalView().create(with: .number))
        views.append(EditNormalView().create(with: .email))
        views.append(EditNormalView().create(with: .uppercase))
        views.append(EditNormalView().create(with: .phone))
        views.append(EditNormalView().create(with: .fio))

        for (key, view) in views.enumerated() {
            scrollView.addSubview(view)
            view.widthAnchor == scrollView.widthAnchor
            view.leadingAnchor == scrollView.leadingAnchor
            view.trailingAnchor == scrollView.trailingAnchor

            if key == 0 {
                view.topAnchor == scrollView.topAnchor

            } else if key - 1 >= 0 {
                let aboveView = views[key - 1]
                view.topAnchor == aboveView.bottomAnchor
            }
        }

        scrollView.widthAnchor == view.widthAnchor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

