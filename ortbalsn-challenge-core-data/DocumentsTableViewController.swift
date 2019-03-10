//
//  DocumentsTableViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit
import CoreData

class DocumentsTableViewController: UITableViewController {
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    var documents = [Document]()
    
    var filteredDocuments = [Document]()
    
    let dateFormatter = DateFormatter()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        do {
            documents = try managedContext.fetch(fetchRequest)
            filteredDocuments = documents
            tableView.reloadData()
        } catch {
            print("Could not fetch documents")
        }
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = filteredDocuments[indexPath.row]
        
        if let managedContext = document.managedObjectContext {
            managedContext.delete(document)
            
            do {
                try managedContext.save()
                
                self.filteredDocuments.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch{
                print("Could not delete document")
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDocuments.count
        }

        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        let document: Document
        if isFiltering() {
            document = filteredDocuments[indexPath.row]
        }
        else {
            document = documents[indexPath.row]
        }
        
        if let cell = cell as? DocumentTableViewCell {
            cell.titleLabel.text = document.title
            
            if let dateModified = document.dateModified {
                cell.modifiedLabel.text = dateFormatter.string(from: dateModified)
            }
            
            if let size = document.size {
                cell.sizeLabel.text = String(size) + " bytes"
            }
            else {
                cell.sizeLabel.text = ""
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let document: Document
                if isFiltering(){
                    document = filteredDocuments[selectedRow]
                }
                else {
                    document = documents[selectedRow]
                }
                
                destination.existingDocument = document
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteDocument(at: indexPath)
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDocuments = documents.filter({( document : Document) -> Bool in
            return documentContainsText(document: document, text: searchText)
        })
        
        tableView.reloadData()
    }
        
    func documentContainsText(document: Document, text: String)  -> Bool{
        if let title = document.title {
            if title.lowercased().contains(text.lowercased()) {
                return true
            }
        }
        
        if let content = document.content {
            if content.lowercased().contains(text.lowercased()) {
                return true
            }
        }
        
        return false
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension DocumentsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
