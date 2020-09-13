//
//  LocalDatabaseManager.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit
import CoreData

class LocalDatabaseManager {
    static let shared = LocalDatabaseManager()
    private var dataQueue = DispatchQueue(
        label: Bundle.main.bundleIdentifier ?? "" + ".core-data-queue",
        qos: .default
    )
    private var managedContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinderLike")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getFavPeople(completionHandler: @escaping ((Result<[People], APIError>) -> Void)) {
        dataQueue.sync {
            var result: Result<[People], APIError>

            do {
                let fetchResults = try self.managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Person"))
                let people = fetchResults.compactMap({ People(with: $0) })
                result = .success(people)
            } catch {
                result = .failure(.notfound)
            }
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func getPeople(withId id: String, needDelteRecord needDelete: Bool = false, completionHandler: @escaping ((Result<People, APIError>) -> Void)) {
        dataQueue.sync {
            var result: Result<People, APIError>

            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                fetchRequest.fetchLimit = 1
                let fetchResults = try self.managedContext.fetch(fetchRequest)
                
                if let person = fetchResults.compactMap({ People(with: $0) }).first {
                    result = .success(person)
                    if needDelete {
                        fetchResults.forEach({ managedContext.delete($0) })
                        saveContext()
                    }
                } else {
                    result = .failure(.notfound)
                }
            } catch {
                result = .failure(.invalidData)
            }
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func cleanDatabase() {
        dataQueue.sync {
            do {
                let fetchResults = try self.managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Person"))
                fetchResults.forEach({ managedContext.delete($0) })
                saveContext()
            } catch let error {
                print("fetch get error \(error)")
            }
        }
    }
    
    func savePeople(_ people: People) throws {
        dataQueue.sync {
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            let keyPath = People.CoreDataKeyPath.self
            person.setValue(people.id, forKeyPath: keyPath.id.rawValue)
            person.setValue(people.name.title.rawValue, forKeyPath: keyPath.title.rawValue)
            person.setValue(people.name.first, forKeyPath: keyPath.firstName.rawValue)
            person.setValue(people.name.last, forKeyPath: keyPath.lastName.rawValue)
            person.setValue(people.location.coordinates.latitude, forKeyPath: keyPath.lat.rawValue)
            person.setValue(people.location.coordinates.longitude, forKeyPath: keyPath.long.rawValue)
            person.setValue(people.location.street.name, forKeyPath: keyPath.streetName.rawValue)
            person.setValue(people.location.street.number, forKeyPath: keyPath.streetNumber.rawValue)
            person.setValue(people.location.city, forKeyPath: keyPath.city.rawValue)
            person.setValue(people.location.state, forKeyPath: keyPath.state.rawValue)
            person.setValue(people.location.country, forKeyPath: keyPath.country.rawValue)
            person.setValue(people.dob.date, forKeyPath: keyPath.dateOfBirh.rawValue)
            person.setValue(people.dob.age, forKeyPath: keyPath.age.rawValue)
            person.setValue(people.phone, forKeyPath: keyPath.phone.rawValue)
            person.setValue(people.pictureUrl, forKeyPath: keyPath.pictureUrl.rawValue)
            person.setValue(people.isFav, forKeyPath: keyPath.isFav.rawValue)
            
            saveContext()
        }
    }
}

extension People {
    init?(with fetchResult: NSManagedObject) {
        let keyPath = People.CoreDataKeyPath.self
        guard
            let id = fetchResult.value(forKeyPath: keyPath.id.rawValue) as? String,
            let titleRawValue = fetchResult.value(forKeyPath: keyPath.title.rawValue) as? String,
            let title = Title(rawValue: titleRawValue),
            let firstName = fetchResult.value(forKeyPath: keyPath.firstName.rawValue) as? String,
            let lastName = fetchResult.value(forKeyPath: keyPath.lastName.rawValue) as? String,
            let lat = fetchResult.value(forKeyPath: keyPath.lat.rawValue) as? String,
            let long = fetchResult.value(forKeyPath: keyPath.long.rawValue) as? String,
            let streetName = fetchResult.value(forKeyPath: keyPath.streetName.rawValue) as? String,
            let streetNumber = fetchResult.value(forKeyPath: keyPath.streetNumber.rawValue) as? Int,
            let city = fetchResult.value(forKeyPath: keyPath.city.rawValue) as? String,
            let state = fetchResult.value(forKeyPath: keyPath.state.rawValue) as? String,
            let country = fetchResult.value(forKeyPath: keyPath.country.rawValue) as? String,
            let dateOfBirh = fetchResult.value(forKeyPath: keyPath.city.rawValue) as? String,
            let age = fetchResult.value(forKeyPath: keyPath.age.rawValue) as? Int,
            let phoneNum = fetchResult.value(forKeyPath: keyPath.phone.rawValue) as? String,
            let isFav = fetchResult.value(forKeyPath: keyPath.isFav.rawValue) as? Bool,
            let pictureUrl = fetchResult.value(forKeyPath: keyPath.pictureUrl.rawValue) as? String
            else { return nil }
        let name = Name(
            title: title,
            first: firstName,
            last: lastName
        )
        let location = Location(
            street: Street(number: streetNumber, name: streetName),
            city: city,
            state: state,
            country: country,
            coordinates: Coordinates(latitude: lat, longitude: long))
        let dob = Dob(date: dateOfBirh, age: age)
        
        self.name = name
        self.location = location
        self.id = id
        self.dob = dob
        self.phone = phoneNum
        self.picture = Picture(medium: pictureUrl)
        self.isFav = isFav
    }
}
