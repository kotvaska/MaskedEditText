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

        let views = getMaskedViews()
        initScrollView(with: views)
        updateScrollViewHeight()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewHeight()
    }

    private func getMaskedViews() -> [UIView] {
        var views = [UIView]()

        views.append(EditExtendedView())
        views.append(EditExtendedView().create(with: .number, isMultiLine: false))
        views.append(EditExtendedView().create(with: .uppercase))
        views.append(EditExtendedView().create(with: .fio, isMultiLine: false))
        views.append(EditNormalView().create(with: .email))
        views.append(EditNormalView().create(with: .phone))

        return views
    }

    private func initScrollView(with views: [UIView]) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

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

    private func updateScrollViewHeight() {
        var height: CGFloat = 0
        if let lastView = scrollView.subviews.filter({ $0 is EditNormalView }).last {
            height = lastView.frame.height + lastView.frame.origin.y
        }

        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: height)
    }


}

