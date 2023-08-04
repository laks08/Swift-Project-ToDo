//
//  DetailedTableViewController.swift
//  assignment8
//
//  Created by Lakshya Gupta on 4/29/23.
//

import UIKit
import CoreData

class DetailedTableViewController: UITableViewController {
    
    @IBOutlet weak var tableView1: UITableView!
    
    var categoriesAndAmounts: [(category: String, amount: Float)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch the expenses from Core Data and calculate the total amount for each category
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        do {
            let expenses = try context.fetch(fetchRequest)
            var categoryToAmount: [String: Float] = [:]
            for expense in expenses {
                if let category = expense.category {
                    categoryToAmount[category] = (categoryToAmount[category] ?? 0) + expense.amount
                }
            }
            categoriesAndAmounts = categoryToAmount.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesAndAmounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categoriesAndAmounts[indexPath.row].category
        let amount = categoriesAndAmounts[indexPath.row].amount
        cell.textLabel?.text = "\(category): $\(amount)"
        return cell
    }

}
