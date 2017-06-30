//
//  ViewController.swift
//  Basic Core Data Login
//
//  Created by David Kooistra on 5/24/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var isLoggedIn = false
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoggedIn {
            // changing username
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        result.setValue(textField.text, forKey: "username")
                        
                        do{
                            try context.save()
                            
                        } catch {
                            print("Save username failed")
                        }
                        
                    }
                    label.alpha = 1
                    label.text = "Hi there \(textField.text!)!"
                    
                    isLoggedIn = true
                    
                }
                
                
                
            } catch {
                
                print("Update username failed")
            }
            
            
        }
        else{
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            
            newUser.setValue(textField.text, forKey: "username")
            
            do {
                
                try context.save()
                label.alpha = 1
                label.text = "Hi there " + textField.text! + "!"
                logoutLabel.alpha = 1
                button.setTitle("Change Username", for: [])
                isLoggedIn = true
                
            } catch {
                
                print("Failed to save")
                
            }
        }
    }
    
    @IBOutlet weak var logoutLabel: UIButton!
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        // Delete everything from core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results {
                    
                    context.delete(result as! NSManagedObject)
                    
                    do {
                        
                        try context.save()
                        
                    } catch {
                        
                        print("Individual delete failed")
                    }
                }
                
                button.setTitle("Login", for: [])
                button.alpha = 1
                logoutLabel.alpha = 0
                textField.text = ""
                label.alpha = 0
                isLoggedIn = false
            
            }
            else {
                print("Nothing in database")
            }
            
        } catch {
            
            print("Delete failed")
        }
        
        logoutLabel.alpha = 0
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        logoutLabel.alpha = 0
        
        do {
            
            let results = try context.fetch(request)
            
            for result in results as! [NSManagedObject]{
                
                if let username = result.value(forKey: "username") as? String {
                    
                    button.setTitle("Change Username", for: [])
                    label.text = "Hi there " + username + "!"
                    label.alpha = 1
                    logoutLabel.alpha = 1
                    isLoggedIn = true
                    
                }
                
            }
            
            
        } catch {
            
            print("Request Failed")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

