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

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, QuestionCellDelegate, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var isReviewMode:Bool = false
    var currentCategory:String  = ALL_CATEGORY
    
    private var myAnswersDict:Dictionary<Int16, Int16> = Dictionary()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: reuseID, bundle: Bundle.main), forCellReuseIdentifier: reuseID)
        self.initializeFetchedResultsController()
        self.LoadUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ActivitiesManager.shared.updateMyAnswerForQuestion(myAnswerDict: self.myAnswersDict)
    }
    
    
    func LoadUI() {
        tableView.isPagingEnabled = true
        tableView.rowHeight = view.bounds.width
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        // 旋转
        view.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        self.updateTitle()
    }
    
    func scrollToTop () {
        let desiredOffset = CGPoint(x: 0, y: -self.tableView.contentInset.top)
        self.tableView.setContentOffset(desiredOffset, animated: true)
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        
        // In case of using predicate when updating 
        let p1 = currentCategory != ALL_CATEGORY ? NSPredicate(format: "category == %@", currentCategory) : NSPredicate(format: "category LIKE '*'")
        if isReviewMode {
            let p2 = NSPredicate(format: "myAnswer != 0")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        } else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1])
        }
        
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
    
    func getNumberOfItemInSection (section:Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    // MARK: - TableView - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfItemInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! QuestionCell
        cell.delegate = self
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi/2)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) else {
//            fatalError("Wrong cell type dequeued")
//        }
        
        
        guard (self.fetchedResultsController?.object(at: indexPath)) != nil else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        if isReviewMode {
            cell.configureForQuestionView(self.fetchedResultsController?.object(at: indexPath) as! Question)
        } else {
            cell.configureForQuestionStart(self.fetchedResultsController?.object(at: indexPath) as! Question,myAnswersDict )
        }
        
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
    
    // MARK - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateTitle()
    }
    
    func updateTitle(){
        if let index = self.tableView.indexPathsForVisibleRows?.first {
            self.title = String(format:"%d/%d", index.row + 1, self.getNumberOfItemInSection(section: 0))
        }
    }
    
    
    // MARK - QuestionCellDelegate
    func selectedAnswer(id:Int16, myAnswer:Int16) {
        if myAnswersDict[id] != nil {
            myAnswersDict.updateValue(myAnswer, forKey: id)
        } else {
            myAnswersDict[id] = myAnswer
        }
    }
    
}



