//
//  Song.swift
//  
//
//  Created by Sarah Mattar on 2021-11-15.
//

import Fluent
import Vapor

final class Song: Model, Content {
    static let schema = "songs"
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() {}
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
