//
//  StackSetupDemoViewController.swift
//  CoreStoreDemo
//
//  Created by John Rommel Estropia on 2015/05/24.
//  Copyright (c) 2015 John Rommel Estropia. All rights reserved.
//

import UIKit
import CoreStore


private struct Static {
    
    static let johnConfiguration = "SetupDemo_John"
    static let janeConfiguration = "SetupDemo_Jane"
    
    static let facebookStack: DataStack = {
        
        let dataStack = DataStack(modelName: "CoreStoreDemo")
        dataStack.addSQLiteStore(
            "AccountsDemo_FB_John.sqlite",
            configuration: johnConfiguration,
            resetStoreOnMigrationFailure: true
        )
        dataStack.addSQLiteStore(
            "AccountsDemo_FB_Jane.sqlite",
            configuration: janeConfiguration,
            resetStoreOnMigrationFailure: true
        )
        
        dataStack.beginSynchronous { (transaction) -> Void in
            
            transaction.deleteAll(From<UserAccount>(johnConfiguration))
            transaction.deleteAll(From<UserAccount>(janeConfiguration))
            
            let account1 = transaction.create(Into<UserAccount>(johnConfiguration))
            account1.accountType = "Facebook"
            account1.name = "John Smith HCD"
            account1.friends = 42
            
            let account2 = transaction.create(Into<UserAccount>(janeConfiguration))
            account2.accountType = "Facebook"
            account2.name = "Jane Doe HCD"
            account2.friends = 314
            
            transaction.commit()
        }
        
        return dataStack
    }()
    
    static let twitterStack: DataStack = {
        
        let dataStack = DataStack(modelName: "CoreStoreDemo")
        dataStack.addSQLiteStore(
            "AccountsDemo_TW_John.sqlite",
            configuration: johnConfiguration,
            resetStoreOnMigrationFailure: true
        )
        dataStack.addSQLiteStore(
            "AccountsDemo_TW_Jane.sqlite",
            configuration: janeConfiguration,
            resetStoreOnMigrationFailure: true
        )
        
        dataStack.beginSynchronous { (transaction) -> Void in
            
            transaction.deleteAll(From<UserAccount>(johnConfiguration))
            transaction.deleteAll(From<UserAccount>(janeConfiguration))
            
            let account1 = transaction.create(Into<UserAccount>(johnConfiguration))
            account1.accountType = "Twitter"
            account1.name = "#johnsmith_hcd"
            account1.friends = 7
            
            let account2 = transaction.create(Into<UserAccount>(janeConfiguration))
            account2.accountType = "Twitter"
            account2.name = "#janedoe_hcd"
            account2.friends = 100
            
            transaction.commit()
        }
        
        return dataStack
    }()
}




// MARK: - StackSetupDemoViewController

class StackSetupDemoViewController: UITableViewController {
    
    let accounts = [
        [
            Static.facebookStack.fetchOne(From<UserAccount>(Static.johnConfiguration))!,
            Static.facebookStack.fetchOne(From<UserAccount>(Static.janeConfiguration))!
        ],
        [
            Static.twitterStack.fetchOne(From<UserAccount>(Static.johnConfiguration))!,
            Static.twitterStack.fetchOne(From<UserAccount>(Static.janeConfiguration))!
        ]
    ]
    
    
    // MARK: UIViewController
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        self.updateDetailsWithAccount(self.accounts[indexPath.section][indexPath.row])
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(
            title: "Setup Demo",
            message: "This demo shows how to initialize 2 DataStacks with 2 configurations each, for a total of 4 SQLite files, each with 1 instance of a \"UserAccount\" entity.",
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.accounts.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.accounts[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as! UITableViewCell
        
        let account = self.accounts[indexPath.section][indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = "\(account.friends) friends"
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let account = self.accounts[indexPath.section][indexPath.row]
        self.updateDetailsWithAccount(account)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            
        case 0: return "Facebook Accounts"
        case 1: return "Twitter Accounts"
        default: return nil
        }
    }
    
    
    // MARK: Private
    
    @IBOutlet weak var accountTypeLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var friendsLabel: UILabel?
    
    func updateDetailsWithAccount(account: UserAccount) {
        
        self.accountTypeLabel?.text = account.accountType
        self.nameLabel?.text = account.name
        self.friendsLabel?.text = "\(account.friends) friends"
    }
}
