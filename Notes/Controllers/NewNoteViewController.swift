//
//  EntryViewController.swift
//  Notes
//
//  Created by Максим Фасхетдинов on 23.12.2022.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    // MARK: - Lyfecycle

    @IBOutlet private var noteTitleField: UITextField!
    @IBOutlet private var noteTextView: UITextView!
    
    
    public var completion: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSaveButton()
        noteTitleField.becomeFirstResponder()
    }
    
    private func showSaveButton() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave))
    }
    
    @objc private func didTapSave() {
        if let text = noteTitleField.text, !text.isEmpty, !noteTextView.text.isEmpty {
            completion?(text, noteTextView.text)
        }
    }
    

}
