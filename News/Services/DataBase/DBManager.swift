//
//  DBManager.swift
//  News
//
//  Created by Stanislav Povolotskiy on 03.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import RealmSwift

class DBManager {
    private var realm: Realm
    static let sharedInstance = DBManager()
    
    private init() {
       realm = try! Realm()
    }
    
    func getDataFromDB() -> Results<ArticleObject> {
      let results: Results<ArticleObject> = realm.objects(ArticleObject.self)
      return results
    }
    
    func addData(object: ArticleObject)   {
        try! realm.write {
            realm.add(object)
        }
     }
    
    func deleteAllFromDatabase()  {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteFromDb(object: ArticleObject)   {
        try! realm.write {
            realm.delete(object)
        }
    }
}
