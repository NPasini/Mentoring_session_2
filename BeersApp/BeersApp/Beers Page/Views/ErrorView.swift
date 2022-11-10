//
//  ErrorView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 26/08/22.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var errorViewHeight: NSLayoutConstraint!

    var message: String? {
        get { return isVisible ? label.text : nil }
        set { show(message: newValue) }
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    private var hiddenErrorViewHeight: CGFloat { 0 }
    private var visibleErrorViewHeight: CGFloat { 40 }

    override func awakeFromNib() {
        super.awakeFromNib()

        alpha = 0
        label.text = ""
        errorViewHeight.constant = 0
    }

    func show(message: String?) {
        if let message = message {
            label.text = message
            errorViewHeight.constant = visibleErrorViewHeight

            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.alpha = 1
                    self.layoutIfNeeded()
                }
            )
        } else {
            hideMessage()
        }
    }

    func hideMessage() {
        errorViewHeight.constant = hiddenErrorViewHeight

        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.alpha = 0
                self.layoutIfNeeded()
            },
            completion: { completed in
                if completed {
                    self.label.text = ""
                }
            })
    }
}
