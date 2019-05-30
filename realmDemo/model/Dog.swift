//
//  Dog.swift
//  realmDemo
//
//  Created by xww on 2019/5/24.
//  Copyright © 2019 amberoot. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    @objc dynamic var age = 0
    
}

class Human: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    let dogs = List<Dog>()
}


class Person: Object {
//    @objc dynamic var tmpID = 0
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil // optionals supported
    let dogs = List<Dog>()
    
    //指定主键-Once an object with a primary key is added to a Realm, the primary key cannot be changed
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //索引属性-indexes make writes slightly slower, but makes queries using equality and IN operators faster. (It also makes your Realm file slightly larger, to store the index.) It’s best to only add indexes when you’re optimizing the read performance for specific situations.
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    //忽略属性-Ignored properties behave exactly like normal properties. They don’t support any Realm-specific functionality (e.g., they can’t be used in queries and won’t trigger notifications). They can still be observed using KVO.
    override static func ignoredProperties() -> [String] {
        return ["tmpID"]
    }

    
    
}

class Animal: Object {
    //    @objc dynamic var tmpID = 0
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
    //指定主键-Once an object with a primary key is added to a Realm, the primary key cannot be changed
    override static func primaryKey() -> String? {
        return "id"
    }

}


