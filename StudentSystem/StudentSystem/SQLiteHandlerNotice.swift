//
//  SQLiteHandlerNotice.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
import SQLite3
class SQLiteHandlerNotice{
    static let shared = SQLiteHandlerNotice()
    let dbpath = "studentdata1.sqlite"
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
            CREATE TABLE IF NOT EXISTS notice(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            n_name TEXT,
            dis TEXT);
            """
        
        var createTableSattement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableSattement, nil) == SQLITE_OK{
            if sqlite3_step(createTableSattement) == SQLITE_DONE{
                print("notice table created")
            }else{
                print("notice table could not be created")
            }
            
        }else{
            print("notice table could not be prepared")
        }
        sqlite3_finalize(createTableSattement)
    }
    func insert(not: Notice, completion: @escaping ((Bool) -> Void)){
        let insertStatementstring = "Insert into notice(n_name,dis) VALUES (?,?);"
        
        var insertStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementstring, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(insertStatement, 1, (not.n_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (not.dis as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("insert row successfully notice")
                completion(true)
            }else{
                print("could row insert row notice")
                completion(false)
            }
            
        }else{
            print("insert statement could not be prepared notice")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(insertStatement)
    }
    
    func delete(for id:Int, completion: @escaping ((Bool)-> Void)){
        let deleteString = "DELETE FROM notice WHERE id = ?;"
        
        var deleteStatement:OpaquePointer? = nil
        
        // Prepare Statement
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            // Evalute statement
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
                print("delete row successfully notice")
                completion(true)
            }else{
                print("could  delete row notice")
                completion(false)
            }
        }else{
            print("delete statement could not be prepared notice")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(deleteStatement)
    }
    func update(not:Notice, completion: @escaping ((Bool)-> Void)){
        let updateString = "UPDATE notice SET n_name = ?, dis = ? WHERE id = ?;"
        
        var updateStatement:OpaquePointer? = nil
        
        // Prepare Statement
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK{
            sqlite3_bind_text(updateStatement, 1, (not.n_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (not.dis as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(not.id))
            
            // Evalute statement
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                print("update row successfully notice")
                completion(true)
            }else{
                print("could row update row notice")
                completion(false)
            }
        }else{
            print("update statement could not be prepared notice")
            completion(false)
        }
        //Delete statement
        sqlite3_finalize(updateStatement)
    }
    func fetch() -> [Notice]{
        let fetchString = "SELECT * FROM notice;"
        
        var fetchStatement:OpaquePointer? = nil
        var stud = [Notice]()
        // Prepare Statement
        if sqlite3_prepare_v2(db, fetchString  , -1, &fetchStatement, nil) == SQLITE_OK{
            // Evalute statement
            while sqlite3_step(fetchStatement) == SQLITE_ROW{
                
                print("fetch row successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let n_name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let dis = String(cString: sqlite3_column_text(fetchStatement, 2))
               
                stud.append(Notice(id: id, n_name: n_name, dis: dis))
                print("\(id) \(n_name) \(dis)")
            }
            
        }else{
            print("select statement could not be prepared")
            
        }
        //Delete statement
        sqlite3_finalize(fetchStatement)
        return stud
}
}
