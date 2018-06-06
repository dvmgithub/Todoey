//
//  Category.swift
//  Todoey
//
//  Created by David Viñaras on 1/6/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorCategory: String? = ""
    let items = List<Item>()
}
