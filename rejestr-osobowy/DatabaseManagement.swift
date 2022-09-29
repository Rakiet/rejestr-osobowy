//
//  DatabaseManagement.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 29/09/2022.
//

import UIKit
import CoreData

class DatabaseManagement: NSManagedObject {
    
    
    class func saveData(firstName: String?, lastName: String?, town: String?, street: String?, zipCode: Int16?, houseNumber: String?, apartmentNumber: String?, sex: Bool?, dateOfBirth: Date?) throws {
        
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let create = NSManagedObject(entity: entity!, insertInto: context)
        create.setValue(firstName, forKey: "firstName")
        create.setValue(lastName, forKey: "lastName")
        create.setValue(town, forKey: "town")
        create.setValue(street, forKey: "streetName")
        create.setValue(zipCode, forKey: "zipCode")
        create.setValue(houseNumber, forKey: "houseNumber")
        create.setValue(apartmentNumber, forKey: "apartmentNumber")
        create.setValue(sex, forKey: "sex")
        create.setValue(dateOfBirth, forKey: "dateOfBirth")
        
        do{
            try context.save()
            print("saved")
        } catch{
            throw error
            
        }
    }
    
    class func readBase()throws -> [Person] {
        var personFromCoreData:[Person] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        do {
            personFromCoreData = try (context.fetch(request) as! [Person])
        } catch {
            throw error
        }
        return personFromCoreData
    }
    
    class func deleteData(taskToDelete: Person) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(taskToDelete as NSManagedObject)
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }

        }
}
