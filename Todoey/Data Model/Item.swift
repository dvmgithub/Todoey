//
//  Item.swift
//  Todoey
//
//  Created by David Viñaras on 1/6/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var check: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
