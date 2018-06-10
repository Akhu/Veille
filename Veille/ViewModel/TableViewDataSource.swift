//
//  TableViewDataSource.swift
//  Veille
//
//  Created by Anthony Da Cruz on 05/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSFetchRequestResult //Is not mandatory to implement since we respect the configure function parameters type
    associatedtype Cell: UITableViewCell
    
    func configure(_ cell: Cell, for object: Object)
}

//This means that when you instanciate a new TableViewDataSource, Delegate will take the type of TableViewDataSourceDelegate we want
class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    //We have to declare them in the instance var level to be able to access them throughout the class
    typealias Object = Delegate.Object //
    typealias Cell = Delegate.Cell //So the Delegate is the Generic representation of any TableViewDataSourceDelegate compliant class
    
    // - Private
    fileprivate let tableView: UITableView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate let cellIdentifier: String
    
    required init(tableView: UITableView, cellIdentifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.delegate = delegate
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    
    // MARK: TableViewDataSourceDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? Cell else { fatalError("Unexpected Cell Type") }
        let object = self.objectAtIndexPath(indexPath: indexPath)
        self.delegate.configure(cell, for: object)
        return cell
    }
    
    var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return self.objectAtIndexPath(indexPath: indexPath)
    }
    
    func objectAtIndexPath(indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    
    // MARK: Fetched Result controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should not be nil") }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            break
            
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should not be nil") }
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            break
        case .move:
            guard let newIndexPath = newIndexPath else { fatalError("Index path should not be nil") }
            guard let indexPath = indexPath else { fatalError("Index path should not be nil") }
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
            break
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should not be nil") }
            let objectUpdated = self.objectAtIndexPath(indexPath: indexPath)
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? Cell else { fatalError("Can't instanciate or find Cell")}
            self.delegate.configure(cell, for: objectUpdated)
            
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}
