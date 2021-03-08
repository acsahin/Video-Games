//
//  LocalDBNetwork.swift
//  Video Games
//
//  Created by ACS on 7.03.2021.
//

import Foundation
import UIKit
import CoreData

//Local database is used with singleton
//If any changes happens in DetailView (Save OR Delete)
//FavouritesView knows it immediately
//Because, singleton's (shared) delegate
//is fav view's itself

class LocalDBNetwork {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //This is weak
    //Because of singleton
    weak var delegate: LocalDBDelegate?
    
    var vgArray = [LocalVideoGame]()
    
    static let shared = LocalDBNetwork()
    
    func saveVideoGame() {
        do {
            try context.save()
            self.loadVideoGames()
        } catch {
            print("Error, saving context: \(error.localizedDescription)")
        }
    }
    
    func loadVideoGames() {
        vgArray.removeAll()
        let request: NSFetchRequest<LocalVideoGame> = LocalVideoGame.fetchRequest()
        do {
            vgArray = try context.fetch(request)
            self.delegate?.didUpdateVideoGames(self, videoGames: vgArray)
        }catch {
            print("Error, loading from context: \(error.localizedDescription)")
        }
    }
    
    func isVideoGameExist(_ clue: String) -> [LocalVideoGame]? {
        let request: NSFetchRequest<LocalVideoGame> = LocalVideoGame.fetchRequest()
        request.predicate = NSPredicate(format: "slug = %@", clue)
        
        do {
            let objects = try context.fetch(request)
            return objects
        } catch {
            print("Error about deleting: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteVideoGame(_ clue: String) {
        if let objects = isVideoGameExist(clue) {
            for object in objects {
                context.delete(object)
                saveVideoGame()
            }
        }
    }
}

protocol LocalDBDelegate: class {
    func didUpdateVideoGames(_ localDBNetwork: LocalDBNetwork, videoGames: [LocalVideoGame])
}
