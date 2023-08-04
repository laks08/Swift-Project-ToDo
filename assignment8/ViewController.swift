//
//  ViewController.swift
//  assignment7
//
//  Created by Lakshya Gupta on 3/17/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalExpense: UILabel!
    var expenses = [Expenses]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload the expenses array and the table view
        reloadExpenses()
        tableView.reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
        
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "amount")])
        let sumED = NSExpressionDescription()
        sumED.expression = sumExpression
        sumED.name = "totalExpense"
        sumED.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = [sumED]
        request.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(request)
            let dict = results.first as? [String: Double]
            let total = dict?["totalExpense"] ?? 0.0
            totalExpense.text = String(format: "Total: $%.2f", total)
        } catch {
            print("Error fetching total expense: \(error)")
        }
    }
    private func reloadExpenses() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        do {
            expenses = try context.fetch(request)
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        
    }
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExpenseCellTableViewCell else {return UITableViewCell()}
        
        let expense = expenses[indexPath.row]
        cell.expenseLabel.text = expense.expense
        cell.expenseCategory.text = expense.category
        cell.expenseAmount.text = "$\(expense.amount)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        90
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = expenses[indexPath.row]
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete the expense from Core Data
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(expense)
            do {
                try context.save()
                reloadExpenses()
                tableView.reloadData()
                // Reload the total expense label
                            let totalAmount = expenses.reduce(0) { $0 + $1.amount }
                            totalExpense.text = "Total: $\(totalAmount)"
            } catch {
                print("Error deleting expense: \(error.localizedDescription)")
            }
        }
    }
    
}
