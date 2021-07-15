//
//  Student.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import Foundation

class Student{
    
    var id:Int = 0
    var name:String = ""
    var email:String = ""
    var dept:String = ""
    var pwd:String = ""
    
    init(id:Int, name:String, email:String, dept:String ,pwd:String) {
        self.id = id
        self.name = name
        self.email = email
        self.dept = dept
        self.pwd = pwd
    }
}
