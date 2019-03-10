//
//  DocumentViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var existingDocument: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveDocument))
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        titleTextField.text = existingDocument?.title
        contentTextView.text = existingDocument?.content
    }
    
    @objc
    func saveDocument() {
        let title = titleTextField.text
        let content = contentTextView.text
        
        var document: Document?
        if let existingDocument = existingDocument {
            existingDocument.title = title
            existingDocument.content = content
            existingDocument.dateModified = Date()
            existingDocument.size = content?.utf8.count
            
            document = existingDocument
        }
        else {
            document = Document(title: title, content: content)
        }
        
        if let document = document{
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch{
                print("Document not saved")
            }
        }
    }

}
