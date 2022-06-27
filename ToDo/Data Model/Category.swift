//
//  Category.swift
//  ToDo
//
//  Created by Tanaka Mawoyo on 27.06.22.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name:  String = ""
    
    //Forward relationship for database relationships
    let items = List<Item>()
}
