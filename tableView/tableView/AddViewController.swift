//
//  AddViewController.swift
//  tableView
//
//  Created by miyazawaryohei on 2020/08/18.
//  Copyright © 2020 miya. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    
    @IBOutlet var saveButton: UIBarButtonItem!
    enum Mode {
        case add,edit
    }
    
    var mode = Mode.add
    
    var fruitName = String()
    
    @IBOutlet var addTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        
        if mode == .edit{
            addTextField.text = fruitName
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let identifier: String
        switch mode {
        case .add:
            identifier = "exitSaveAddSegue"
        case .edit:
            identifier = "exitSaveEditSegue"
        }
        performSegue(withIdentifier: identifier, sender: sender)
    }
    //textFieldが空あったらsaveボタンを押せなくする
    @IBAction func textFieldCheck(_ sender: Any) {
        updateSaveButton()
    }
    private func updateSaveButton() {
        if addTextField.text ?? "" == ""{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
    }
}
