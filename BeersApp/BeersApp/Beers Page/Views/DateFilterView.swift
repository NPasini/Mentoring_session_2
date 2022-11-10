//
//  DateFilterView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 30/08/22.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelectFirstBrewingDate(_ date: Date)
}

class DateFilterView: UIView {

    @IBOutlet private(set) var dateTextField: UITextField!

    weak var delegate: FilterDelegate?

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        configureToolBar(of: dateTextField, withDatePicker: datePicker)
        dateTextField.text = "Show all"
    }

    private func configureToolBar(of textField: UITextField, withDatePicker datePicker: UIDatePicker) {
        textField.inputView = datePicker

        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: BeersPresenter.done, style: .plain, target: self, action: #selector(doneAction))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }

    @objc private func doneAction() {
        let selectedDate = Date.prettyPrintFirstBrewedDate(datePicker.date)
        dateTextField.text = selectedDate.stringFormat
        dateTextField.endEditing(true)
        delegate?.didSelectFirstBrewingDate(selectedDate.dateFormat)
    }
}
