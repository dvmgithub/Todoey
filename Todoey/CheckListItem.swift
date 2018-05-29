//
//  CheckListItem.swift
//  Todoey
//
//  Created by David Viñaras on 28/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import Foundation

class CheckListItem: Codable  {
    var title: String = ""
    var checked: Bool = true
    
    func toogleChecked() {
        checked = !checked
    }

}
