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

extension Connection{
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}

struct FMDB: FMDatabase{
    var db: Connection?
    let id = Expression<Int64>("id")
    let numberFamilyMembers = Expression<Int64>("numberFamilyMembers")
    let breastTimeLeft = Expression<Int64?>("breastTimeLeft")
    let suspendTimestamp = Expression<Int64?>("suspendTimestamp")
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
    
    func performMigrations() throws{
        guard let db = db else{
            throw DMError.NoConnection
        }
        if(db.userVersion == 0){
            do{
                try db.run(users.drop())
            } catch{}
            do{
                try db.run(users.create(ifNotExists: true) { t in
                    t.column(id, primaryKey: true)
                    t.column(numberFamilyMembers)
                    t.column(breastTimeLeft)
                    t.column(suspendTimestamp)
                })
                
                try insertUser()
            } catch let e{
                throw e
            }
            db.userVersion = 1
        }
    }
    
    func createTables() throws{
        do{
            try performMigrations()
        } catch(let e){
            throw e
        }
    }
    
    func getUser() throws -> Row{
        guard let db = db else{
            throw DMError.NoConnection
        }
        if let user = try db.pluck(users){
            return user
        } else{
            throw DMError.NoUser
        }
    }
    
    func insertUser() throws{
        guard let db = db else{
            throw DMError.NoConnection
        }
        if let _ = try db.pluck(users){ return }
        let _ = try db.run(users.insert([numberFamilyMembers <- 0, breastTimeLeft <- nil, suspendTimestamp <- nil]))
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
    
    func updateBreastTimer(timeLeft: Int64, suspendTime: Int64) throws{
        let _ = try db?.run(users.update([breastTimeLeft <- timeLeft, suspendTimestamp <- suspendTime]))
    }
    
    func getBreastTimer() throws -> (Int64?, Int64?){
        do{
            let user = try getUser()
            return (user[breastTimeLeft], user[suspendTimestamp])
        } catch let e{
            throw e
        }
    }
}
