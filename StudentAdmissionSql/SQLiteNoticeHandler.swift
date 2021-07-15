//
//  SQLiteNoticeHandler.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteNoticeHandler
{
    static let shared = SQLiteNoticeHandler()
    
    let dbPath = "studDB.sqlite"
    var db:OpaquePointer?
    
    private init(){
        db = openDatabase()
        createTable()
    }
    func openDatabase() -> OpaquePointer?
    {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docURL.appendingPathComponent(dbPath)
        
        var database:OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &database) == SQLITE_OK
        {
            print("Connection Opened")
            return database
        }
        else{
            print("Error connection")
            return nil
        }
    }
    
    func createTable()
    {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS note(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notice TEXT);
        """
        
        var createTableStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("succesful created table")
            }
            else
            {
                print("not succesfully created table")
            }
            
        }
        else
        {
            print("Create table statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)//destroy statement
    }
    
    //insert
    func insert(note:Notice , completion: @escaping ((Bool) -> Void))//func insert(spid:String, name:String ,div:String)
    {
        let insertStatementString = "INSERT INTO note (notice) VALUES(?);"
        var insertStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(insertStatement, 1, (note.notice as NSString).utf8String, -1, nil)
            //evaluate statement
                if sqlite3_step(insertStatement) == SQLITE_DONE
                {
                    print("succesful inserted")
                    completion(true)
                }
                else
                {
                    print("not succesfully inserted")
                    completion(false)
                }
        }
        else
        {
            print("Insert statement could not be prepared")
            completion(false)
        }
        sqlite3_finalize(insertStatement)
    }
    
    //update
    func update(note:Notice , completion: @escaping ((Bool) -> Void))
    {
        let updateStatementString = "UPDATE note SET notice = ? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(updateStatement, 1, (note.notice as NSString).utf8String, -1, nil)
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
    
    
    //fetch
    func fetch()->[Notice]
    {
        let fetchStatementString = "SELECT * FROM note;"
        var fetchStatement:OpaquePointer? = nil
        
        var note = [Notice]()
        
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK
        {
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let notice = String(cString: sqlite3_column_text(fetchStatement, 1))

                note.append(Notice(id: id, notice: notice))
                
                print("Query Result:")
                print("\(id) \t \(notice)")
            }
        }
        else
        {
            print("Select statement could not be prepared")
        }
        sqlite3_finalize(fetchStatement)
        return note
    }
    
}
