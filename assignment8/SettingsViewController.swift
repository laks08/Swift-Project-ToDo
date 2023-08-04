//
//  SettingsViewController.swift
//  assignment8
//
//  Created by Lakshya Gupta on 4/29/23.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func eraseAll(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete all data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                print("All data erased successfully.")
            } catch {
                print("Error erasing all data: \(error.localizedDescription)")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
