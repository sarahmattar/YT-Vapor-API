//
//  SongController.swift
//  
//
//  Created by Sarah Mattar on 2021-11-15.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    //the first function that will run
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        // need something slightly different for urls with params
        songs.group(":songID") {
            song in song.delete(use: delete)
        }
        
    }
    
    //route for /songs
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST Request
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
        
    }
    
    //PUT Request
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return Song.find(song.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.title = song.title
            return $0.update(on: req.db).transform(to: .ok)
        }
    }
    
    //DEL Request using params /songs/id

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("songID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap {
            $0.delete(on: req.db)
        }.transform(to: .ok)
    }
}
