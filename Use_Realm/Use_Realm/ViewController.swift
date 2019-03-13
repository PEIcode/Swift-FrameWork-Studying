//
//  ViewController.swift
//  Use_Realm
//
//  Created by 廖佩志 on 2019/3/11.
//  Copyright © 2019 廖佩志. All rights reserved.
//

//        Realm.Configuration(fileURL: <#T##URL?#>, inMemoryIdentifier: <#T##String?#>, syncConfiguration: <#T##SyncConfiguration?#>, encryptionKey: <#T##Data?#>, readOnly: <#T##Bool#>, schemaVersion: <#T##UInt64#>, migrationBlock: <#T##MigrationBlock?##MigrationBlock?##(Migration, UInt64) -> Void#>, deleteRealmIfMigrationNeeded: <#T##Bool#>, shouldCompactOnLaunch: <#T##((Int, Int) -> Bool)?##((Int, Int) -> Bool)?##(Int, Int) -> Bool#>, objectTypes: <#T##[Object.Type]?#>)

import UIKit
import RealmSwift

class ViewController: UIViewController {
    var fileURL: URL = (Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent("a.realm"))!

    let config = Realm.Configuration()
    var token: NotificationToken?
    ///指定默认数据库的路径（Configuring a Local Realm）
    func setDefaultRealm(name: String) {
        var config = Realm.Configuration()

        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(name).realm")

//    Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent("\(name).realm")

        Realm.Configuration.defaultConfiguration = config
    }
    let config2 = Realm.Configuration(
        // Get the URL to the bundled file
        fileURL: Bundle.main.url(forResource: "MyBundledData", withExtension: "realm"),
        // Open the file in read-only mode as application bundles are not writeable
        readOnly: true)

    override func viewDidLoad() {
        super.viewDidLoad()
//        let myDog = Dog()
//        myDog.name = "Jack"
//        myDog.age = 1
//        // Realm，默认数据库
//        setDefaultRealm(name: "a")
//        // open realm
//        let realm = try! Realm()
//        //如果第一次打开，查找Realm中所有的dog，应该为0
//        let puppies = realm.objects(Dog.self).filter("age < 2")
//        print(puppies.count)
//
//        try! realm.write {
//            realm.add(myDog)
//        }
//
//        print(puppies.count)

//        DispatchQueue(label: "background").async {
//            let realm = try! Realm()
//            let theDog = realm.objects(Dog.self).filter("age == 1").first
//            try! realm.write {
//                theDog?.age = 3
//            }
//
//        }

//        creatRealm()

//        mergeRealm()

        testNotifaction()
    }
//    #warning ("需要做什么")

//    #error ("hahaha")
    //创建Realm数据库
    func creatRealm() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let filePath = path + "/lpz.realm"
        let fileUrl = URL(fileURLWithPath: filePath)
        try? FileManager.default.removeItem(at: fileUrl)
        print(fileUrl)
        //有两种初始化方式
        //Realm(configuration: )
        if FileManager.default.fileExists(atPath: filePath) {

        }
        let realm2 = try! Realm(fileURL: fileUrl)

        let person = Person()
        person.age = 20
        person.name = "lpz"

        try? realm2.write {
            realm2.add(person)
        }

    }
    ///数据库迁移
    func mergeRealm() {
        let configV3 = Realm.Configuration(fileURL: fileURL, readOnly: false, schemaVersion: 2, migrationBlock: { (migration,oldSchemaVersion ) in
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: Person.className(), { (oldObject, newObject) in
                    newObject!["address"] = "天门市"
                })
            }
        }, deleteRealmIfMigrationNeeded: false)

        Realm.Configuration.defaultConfiguration = configV3
        let realm = try! Realm()
        let p = Person()
        p.name = "lpz"
        p.age = 20
        p.job = "iOS"
        p.address = "天门市"

        try! realm.write {
            realm.add(p)
        }
        print(realm.configuration.fileURL!)
    }
    /// NOtifiaction
    func testNotifaction() {
        let realm = try! Realm()
        guard let result = realm.objects(Person.self).last else {
            return
        }

        try! realm.write {
            result.age = 80
            result.address = "北京"
        }

        token = result.observe { (change) in
            switch change {
            case .error(let error):
                print(error)
            case .change(let properties):
                print("打算修改")
                for property in properties {
                    if property.name == "age" && property.newValue as! Int > 50 {
                        print("姓名修改成功！")
                        self.token = nil
                    }
                    if property.name == "address" {
                        print("地址修改成功")
                        self.token = nil
                    }
                }
            case .deleted:
                print("The object was deleted")
            }

        }

    }

    deinit {
        token?.invalidate()
    }
}


