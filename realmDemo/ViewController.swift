//
//  ViewController.swift
//  realmDemo
//
//  Created by xww on 2019/5/23.
//  Copyright © 2019 amberoot. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //获取realm的实例1
        let realm = try! Realm()
        //获取realm的实例2
//        do {
//            let realm2 = try Realm()
//        } catch let error as NSError {
//            print(error.description)
//        }
        //打印出数据库地址
        print(realm.configuration.fileURL ?? "")
        //在iOS8及以上版本中，只要设备被锁定，应用程序内的文件就会使用NSFileProtection自动加密。如果想要在设备被锁定的情况下进行Realm的操作可以使自动加密功能失效
        // Get our Realm file's parent directory
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        // Disable file protection for this directory
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey:FileProtectionType.none], ofItemAtPath: folderPath)
        
        let myDog = Dog()
        myDog.name = "栗子"
        myDog.color = "black"
        myDog.age = 2
        
        let myOtherDog = Dog(value: ["name":"happy","color":"white","age":1])
//        let myThirdDog = Dog(value: ["dogy","brown",3])
//
//        // Instead of using already existing dogs...
//        let aPerson = Human(value: ["James", 20, [myDog, myOtherDog]])
//        // ...we can create them inline
//        let anotherPerson = Human(value: ["Jane", 30, [["Buster","yellow", 5], ["Buddy","purple", 6]]])

        let animal = Animal(value: [0,"dog"])
        let otherAnimal = Animal(value: [1,"cat"])
        let otherAnimal2 = Animal(value: [1,"elephant"])
        
        // Write
//        try! realm.write {
//            realm.add(animal)
//            realm.add(otherAnimal)
//        }
        
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog.self).filter("age < 3")
        print(puppies.count)
        
        // Query using a predicate string
        let tanDogs = realm.objects(Dog.self).filter("age = 2 AND name BEGINSWITH '栗'")
        print(tanDogs.count)//1
        
        // Query using an NSPredicate
        let predicate = NSPredicate(format: "age = 23 AND name BEGINSWITH %@", "J")
        var tanHuman = realm.objects(Human.self).filter(predicate)
        print(tanHuman.count)//
//        tanHuman = realm.objects(Human.self).filter(predicate).sorted(byKeyPath: "name")
//
//        let dogOwners = realm.objects(Human.self)
//        let ownersByDogAge = dogOwners.sorted(byKeyPath: "dog.age")
        
        // Query and update from any thread
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                let theDog = realm.objects(Dog.self).filter("age == 3").first
                try! realm.write {
                    theDog?.age = 3
                }
            }
        }
        // Update
        let persons = realm.objects(Human.self)
        try? realm.write {
            //把name这列数据的第一个James更新为James blunt(KeyPath是model中的变量)
            persons.first?.setValue("James blunt", forKeyPath: "name")
            //把age这列数据全部更新为23
            persons.setValue(23, forKeyPath: "age")
            //有主键的object可直接更新
            realm.add(otherAnimal2, update: true)
        }
        
        
        
    }

    ///配置realm
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func setCustomRealmConfig() {
        let config = Realm.Configuration(
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "MyBundledData", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)
        
        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)
        // Read some data from the bundled Realm
        let results = realm.objects(Dog.self).filter("age > 5")
    }
    
    
}

