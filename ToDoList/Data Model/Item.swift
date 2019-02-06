//
//  Item.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2019-02-03.
//  Copyright © 2019 gemeDesign. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    var title : String = ""
    var isChecked : Bool = false
}
