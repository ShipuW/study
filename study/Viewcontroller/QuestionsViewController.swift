//
//  QuestionsViewController.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit
import CoreData

private let reuseID = "QuestionCell"

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {

    var isReviewMode:Bool = false
    var currentCategory:String  = ALL_CATEGORY
    
    @IBOutlet weak var tableView: UITableView!
    private var questionArray = [QuestionModel]()
    
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: reuseID, bundle: Bundle.main), forCellReuseIdentifier: reuseID)
        self.initializeFetchedResultsController()
//        self.tableView.reloadData()
        self.LoadUI()
    }
    
    func LoadUI() {
        tableView.isPagingEnabled = true
        tableView.rowHeight = view.bounds.width
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        // 旋转
        view.transform = CGAffineTransform(rotationAngle: -.pi/2)
    }
    
    func scrollToTop () {
        let desiredOffset = CGPoint(x: 0, y: -self.tableView.contentInset.top)
        self.tableView.setContentOffset(desiredOffset, animated: true)
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        
        let p1 = currentCategory != ALL_CATEGORY ? NSPredicate(format: "category == %@", currentCategory) : NSPredicate(format: "category LIKE '*'")
        let p2 = isReviewMode ? NSPredicate(format: "myAnswer != 0") : NSPredicate(format: "myAnswer LIKE '*'")
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let moc = delegate.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - TableView - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        print(sectionInfo.numberOfObjects)
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! QuestionCell
        
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi/2)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) else {
//            fatalError("Wrong cell type dequeued")
//        }
        
        
        guard (self.fetchedResultsController?.object(at: indexPath)) != nil else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        cell.configureForQuestion(self.fetchedResultsController?.object(at: indexPath) as! Question)
        
        
        return cell
    }
    
    
    // MARK - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
}


