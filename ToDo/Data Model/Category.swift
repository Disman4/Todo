//
//  Category.swift
//  ToDo
//
//  Created by Tanaka Mawoyo on 27.06.22.
//

import Foundation
import RealmSwift

//class to create the columns of the database in realm
class Category: Object{
    @objc dynamic var name:  String = ""
    @objc dynamic var color:  String = ""
    //Forward relationship for database relationships
    let items = List<Item>()
}
