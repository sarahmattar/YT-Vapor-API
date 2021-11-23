//
//  CreateSongs.swift
//  
//
//  Created by Sarah Mattar on 2021-11-15.
//

import Fluent

struct CreateSongs: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").id().field("title", .string, .required).create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
}
