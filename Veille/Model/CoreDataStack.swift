//
//  CoreDataStack.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let store = CoreDataStack()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    
    func delete(article: Article){
        
    }
    
    func persistArticle(article: Article){
        do {
            try self.context.save()
            print("Persisting article with title \(article.title)")
        } catch let error as NSError {
            print("persist article error \(error.description)")
        }
    }
    
    func fetchArticleBy(id: Int32) -> Article? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let fetchArticle = try self.context.fetch(fetchRequest) as? [Article] {
                guard fetchArticle.count <= 1 else { fatalError("An article ID must be unique, multiple match found !!!") }
                
                guard let article = fetchArticle.first else { return nil }
                
                return article
            }
            return nil
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        return nil
    }
    
    func fetchArticlesFromCoreData() -> [Article]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let dateSorting = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [dateSorting]
        CustomPersistentContainer.listFileInSharedFolder()
        do {
            if let result = try context.fetch(fetchRequest)  as? [Article] {
                return result
            }
        } catch let error as NSError {
            print("fetchArticle from CoreData \(error.description)")
            return nil
        }
        return nil
    }
    
    lazy var persistentContainer: CustomPersistentContainer = {
       let container = CustomPersistentContainer(name: "Veille")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Persistant model loading error : \(error.description)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Core Data error : \(error.description)")
            }
        }
    }
}

class CustomPersistentContainer: NSPersistentContainer {
    static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.aboutgoods.veille")!
    let storeDescription = NSPersistentStoreDescription(url: url)
    
    static func listFileInSharedFolder(){
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: CustomPersistentContainer.url, includingPropertiesForKeys: nil)
            print(fileURLs)
            let urlUserDestination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("veilleCopy.sqlite")
            try fileManager.copyItem(at: CustomPersistentContainer.url.appendingPathComponent("Veille.sqlite"), to: urlUserDestination)
            
            // process files
        } catch let error as NSError {
            print(error.localizedDescription)
            //print("Error while enumerating files \(CustomPersistentContainer.url): \(error.localizedDescription)")
        }
    }
    
    override class func defaultDirectoryURL() -> URL {
        return url
    }
}
