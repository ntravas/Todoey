//
//  Category.swift
//  Todoey
//
//  Created by Neven Travaš on 04/03/2019.
//  Copyright © 2019 Neven Travaš. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    let items = List<Item>()
}
