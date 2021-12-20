//
//  Student.swift
//  StudentSystem
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation

class Student{
    var id:Int = 0
    var name:String=""
    var age:Int = 0
    var pass:String = ""
    var contactno:String = ""
    var classes:String = ""
    init(id:Int, name:String, age:Int,pass:String, contactno:String,classes:String){
        self.id=id
        self.name=name
        self.age=age
        self.pass=pass
        self.contactno=contactno
        self.classes=classes
    }
}
