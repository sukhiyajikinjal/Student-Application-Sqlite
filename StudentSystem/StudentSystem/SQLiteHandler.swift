//
//  SQLiteHandler.swift
//  StudentSystem
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
import SQLite3
class SQLiteHandler{
    static let shared = SQLiteHandler()
    let dbpath = "studentdata2.sqlite"
    var db:OpaquePointer?
    private init(){
        db = openDatabase()
        createTable()
    }
    func openDatabase() -> OpaquePointer? {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docURL.appendingPathComponent(dbpath)
        var database:OpaquePointer! = nil
        if sqlite3_open(fileURL.path, &database) == SQLITE_OK{
            print("Opened connection to the database successfully at: \(fileURL)")
            return database
        }else{
            print("error connecting to the database")
            return nil
        }
    }
    func createTable(){
        let createTableString = """
            CREATE TABLE IF NOT EXISTS stud(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            pass TEXT,
            contactno TEXT,
            classes TEXT);
            """
        
        var createTableSattement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableSattement, nil) == SQLITE_OK{
            if sqlite3_step(createTableSattement) == SQLITE_DONE{
                print("stud table created")
            }else{
                print("stud table could not be created")
            }

        }else{
            print("stud table could not be prepared")
        }
        sqlite3_finalize(createTableSattement)
    }
    func insert(stud: Student, completion: @escaping ((Bool) -> Void)){
        let insertStatementstring = "Insert into stud(name,age,pass,contactno,classes) VALUES (?,?,?,?,?);"
        
        var insertStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementstring, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(insertStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement,2,Int32(stud.age))
            sqlite3_bind_text(insertStatement, 3, (stud.pass as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (stud.contactno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (stud.classes as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("insert row successfully")
                completion(true)
            }else{
                print("could row insert row")
                completion(false)
            }
           
        }else{
            print("insert statement could not be prepared")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(insertStatement)
    }
    
    func delete(for id:Int, completion: @escaping ((Bool)-> Void)){
        let deleteString = "DELETE FROM stud WHERE id = ?;"
        
        var deleteStatement:OpaquePointer? = nil
        
        // Prepare Statement
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            // Evalute statement
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
                print("delete row successfully")
                completion(true)
            }else{
                print("could  delete row")
                completion(false)
            }
        }else{
            print("delete statement could not be prepared")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(deleteStatement)
    }
    func update(stud:Student, completion: @escaping ((Bool)-> Void)){
        let updateString = "UPDATE stud SET name = ?, age = ?,pass = ?, contactno = ?,classes = ? WHERE id = ?;"
        
        var updateStatement:OpaquePointer? = nil
        
        // Prepare Statement
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(updateStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(stud.age))
             sqlite3_bind_text(updateStatement, 3, (stud.pass as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (stud.contactno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (stud.classes as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 6, Int32(stud.id))
            
            // Evalute statement
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                print("update row successfully")
                completion(true)
            }else{
                print("could row update row")
                completion(false)
            }
        }else{
            print("update statement could not be prepared")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(updateStatement)
    }
    func fetch() -> [Student]{
        let fetchString = "SELECT * FROM stud;"
        
        var fetchStatement:OpaquePointer? = nil
        var stud = [Student]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            while sqlite3_step(fetchStatement) == SQLITE_ROW{
                
                print("fetch row successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let pass = String(cString: sqlite3_column_text(fetchStatement, 3))
                let contactno = String(cString: sqlite3_column_text(fetchStatement, 4))
                let classes = String(cString: sqlite3_column_text(fetchStatement, 5))
                stud.append(Student(id: id, name: name, age: age,pass:pass, contactno: contactno,classes: classes))
                print("\(id) \(name) \(age) \(pass) \(contactno)")
            }
            
        }else{
            print("select statement could not be prepared")
            
        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
    }
    
    func updatepwd(pass:String,id:Int , completion: @escaping ((Bool) -> Void))
    {
        let updateStatementString = "UPDATE stud SET pass = ? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(updateStatement, 1, pass, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            //evaluate statement
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("succesful Updated")
                completion(true)
            }
            else
            {
                print("not succesfully Updated")
                completion(false)
            }
        }
        else
        {
            print("Update statement could not be prepared")
            completion(false)
        }
        sqlite3_finalize(updateStatement)
    }
    func fetchid() -> [Student]{
        let fetchString = "SELECT * FROM stud order by id DESC LIMIT 1;"
        
        var fetchStatement:OpaquePointer? = nil
        var stud = [Student]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            while sqlite3_step(fetchStatement) == SQLITE_ROW{
                
                print("fetch row successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let pass = String(cString: sqlite3_column_text(fetchStatement, 3))
                let contactno = String(cString: sqlite3_column_text(fetchStatement, 4))
                let classes = String(cString: sqlite3_column_text(fetchStatement, 5))
                stud.append(Student(id: id, name: name, age: age,pass:pass, contactno: contactno,classes: classes))
                print("\(id)")
            }
            
        }else{
            print("select statement could not be prepared")
            
        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
    }
    func fetchrecord(for id: Int) -> [Student]{
        let fetchString = "SELECT * FROM stud where id = ?;"

        var fetchStatement:OpaquePointer? = nil
        var stud = [Student]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            sqlite3_bind_int(fetchStatement, 1, Int32(id))
            while sqlite3_step(fetchStatement) == SQLITE_ROW{
                print("fetch row successfully")
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let pass = String(cString: sqlite3_column_text(fetchStatement, 3))
                let contactno = String(cString: sqlite3_column_text(fetchStatement, 4))
                let classes = String(cString: sqlite3_column_text(fetchStatement, 5))
                stud.append(Student(id: id, name: name, age: age,pass:pass, contactno: contactno,classes: classes))
                print("\(id) \(name) \(age) \(pass) \(contactno)")
            }
        }else{
            print("select statement could not be prepared")

        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
    }
    func fetchname() -> [Student]{
        let fetchString = "SELECT * FROM stud where id=1;"

        var fetchStatement:OpaquePointer? = nil
        var stud = [Student]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            while sqlite3_step(fetchStatement) == SQLITE_ROW{

                print("fetch row successfully")

                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let pass = String(cString: sqlite3_column_text(fetchStatement, 3))
                let contactno = String(cString: sqlite3_column_text(fetchStatement, 4))
                let classes = String(cString: sqlite3_column_text(fetchStatement, 5))
                stud.append(Student(id: id, name: name, age: age,pass:pass, contactno: contactno,classes: classes))
                print("\(id) \(name) \(age) \(pass) \(contactno)")
            }

        }else{
            print("select statement could not be prepared")
        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
    }
    func fetchclass(for clas: String) -> [Student]{
        let fetchString = "SELECT * FROM stud where classes = ?;"
        
        var fetchStatement:OpaquePointer? = nil
        var stud = [Student]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            sqlite3_bind_text(fetchStatement, 1, clas,-1,nil)
            while sqlite3_step(fetchStatement) == SQLITE_ROW{
                print("fetch row successfully")
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let pass = String(cString: sqlite3_column_text(fetchStatement, 3))
                let contactno = String(cString: sqlite3_column_text(fetchStatement, 4))
                let classes = String(cString: sqlite3_column_text(fetchStatement, 5))
                stud.append(Student(id: id, name: name, age: age,pass:pass, contactno: contactno,classes: classes))
                print("\(id) \(name) \(age) \(pass) \(contactno)")
            }
        }else{
            print("select statement could not be prepared")
            
        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
    }
}
