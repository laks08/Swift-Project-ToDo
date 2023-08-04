//
//  AddExpense.swift
//  assignment8
//
//  Created by Lakshya Gupta on 4/29/23.
//

import UIKit
import CoreData

class AddExpense: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addExpense: UITextField!
    
    @IBOutlet weak var addCategory: UITextField!
    
    @IBOutlet weak var addAmount: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
                
                // Set text field delegates
                addExpense.delegate = self
                addCategory.delegate = self
                addAmount.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Do any additional setup after loading the view.
        
    }
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
    @objc func keyboardWillShow(notification: Notification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }

            let keyboardHeight = keyboardFrame.height
            let viewHeight = view.frame.height

            let bottomInset = keyboardHeight - (viewHeight - addAmount.frame.maxY)

            if bottomInset > 0 {
                var newFrame = view.frame
                newFrame.origin.y -= bottomInset
                view.frame = newFrame
            }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the return key is pressed
            textField.resignFirstResponder()
            return true
        }
        
        // MARK: - Private methods
        
        @objc private func dismissKeyboard() {
            // Dismiss the keyboard when user taps outside of the text field
            view.endEditing(true)
        }
    
    
    @IBAction func addExpenseBtn(_ sender: Any) {
        // Create a new Expenses object and set its attributes to the user inputs
        
        guard let expense = addExpense.text, !expense.isEmpty,
              let category = addCategory.text, !category.isEmpty,
              let amountString = addAmount.text, !amountString.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter values for all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let newExpense = Expenses(context: context)
        newExpense.expense = expense
        newExpense.category = category
        newExpense.amount = Float(amountString) ?? 0
        
        // Save the changes to Core Data
        do {
            try context.save()
            let alert = UIAlertController(title: "Success", message: "Expense added successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            addExpense.text = ""
            addCategory.text = ""
            addAmount.text = ""
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
    
    
}
