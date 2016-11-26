//
//  FMDatabase.swift
//  FamilyManager
//
//  Created by Ankur Goswami on 11/25/16.
//  Copyright © 2016 SCProjects. All rights reserved.
//

import Foundation
import SQLite

protocol FMDatabase{
    init()
    func createTables() throws
    func insertUser() throws
    func updateFamilyMemberCount() throws
    func getFamilyMemberCount() throws -> Int64
}

enum DMError: Error{
    case NoConnection
    case NoUser
}

struct FMDB: FMDatabase{
    var db: Connection?
    let numberFamilyMembers = Expression<Int64>("numberFamilyMembers")
    let users = Table("users")
    
    init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do{
            db = try Connection("\(path)/db.sqlite3")
        } catch{
            db = nil
        }
        do{
            try createTables()
        } catch{}
    }
    
    func createTables() throws{
        guard let db = db else{
            throw DMError.NoConnection
        }
        
        let id = Expression<Int64>("id")
        
        
        do{
            try db.run(users.create { t in
                t.column(id, primaryKey: true)
                t.column(numberFamilyMembers)
            })
            try insertUser()
        } catch(let e){
            throw e
        }
    }
    
    func insertUser() throws{
        guard let db = db else{
            throw DMError.NoConnection
        }
        let _ = try db.run(users.insert(numberFamilyMembers <- 0))
    }
    
    func updateFamilyMemberCount() throws{
        guard let db = db else{
            throw DMError.NoConnection
        }
        if let user = try db.pluck(users){
            let current = user[numberFamilyMembers]
            let _ = try db.run(users.update(numberFamilyMembers <- (current + 1)))
        } else{
            throw DMError.NoUser
        }
    }
    
    func getFamilyMemberCount() throws -> Int64{
        guard let db = db else{
            throw DMError.NoConnection
        }
        if let user = try db.pluck(users){
            return user[numberFamilyMembers]
        } else{
            throw DMError.NoUser
        }
    }
}
