//
//  Person.swift
//  Use_Realm
//
//  Created by 廖佩志 on 2019/3/11.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit
import RealmSwift

class Person: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0

    override static func primaryKey() -> String? {
        return "name"
    }
}
class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
