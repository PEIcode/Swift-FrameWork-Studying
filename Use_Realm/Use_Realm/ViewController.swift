//
//  ViewController.swift
//  Use_Realm
//
//  Created by 廖佩志 on 2019/3/11.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    let config = Realm.Configuration()
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
        let myDog = Dog()
        myDog.name = "Jack"
        myDog.age = 1
        // Realm，默认数据库
        setDefaultRealm(name: "a")
        // open realm
        let realm = try! Realm()

        //如果第一次打开，查找Realm中所有的dog，应该为0
        let puppies = realm.objects(Dog.self).filter("age < 2")
        print(puppies.count)

        try! realm.write {
            realm.add(myDog)
        }

        print(puppies.count)

//        DispatchQueue(label: "background").async {
//            let realm = try! Realm()
//            let theDog = realm.objects(Dog.self).filter("age == 1").first
//            try! realm.write {
//                theDog?.age = 3
//            }
//
//        }
//        creatRealm()
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

}

