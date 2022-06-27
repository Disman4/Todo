//
//  Item.swift
//  ToDo
//
//  Created by Tanaka Mawoyo on 27.06.22.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated : Date?
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
