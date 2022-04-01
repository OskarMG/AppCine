//
//  PersistentManager.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 28/3/22.
//

import CoreData
import Foundation


class PersistentManager {
    //MARK: - Properties
    static let shared = PersistentManager(modelName: "AppCine")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { [weak self] (storeDescription, error) in
            guard let _ = self else { return }
            guard error == nil else { fatalError(error!.localizedDescription) }
            completion?()
        }
    }
    
    
    //MARK: - Controllers
    func saveContext(successful: @escaping(Bool)->Void) {
        do {
            try viewContext.save()
            DispatchQueue.main.async { successful(true) }
        } catch { DispatchQueue.main.async { successful(false) } }
    }
    
    func getMediaBy(id: String) -> Media? {
        let fetchRequest: NSFetchRequest<Media> = Media.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", id)
        return try? PersistentManager.shared.viewContext.fetch(fetchRequest).first
    }
    
    func deleteMedia(_ id: String, successful: @escaping(Bool)->Void) {
        guard let mediaToDelete = getMediaBy(id: id) else {
            DispatchQueue.main.async { successful(true) }
            return
        }
        
        viewContext.delete(mediaToDelete)
        saveContext(successful: successful)
    }
    
    func addToBookmark(_ media: ACMedia, successful: @escaping(Bool)->Void) {
        let mediaToSave = Media(context: viewContext)
        
        mediaToSave.id               = "\(media.id)"
        mediaToSave.name             = media.name
        mediaToSave.title            = media.title
        mediaToSave.overview         = media.overview
        mediaToSave.type             = media.type.name
        mediaToSave.genderTags       = media.getGenderTags
        mediaToSave.releaseDate      = media.releaseDate
        mediaToSave.voteAverage      = media.voteAverage
        mediaToSave.originalLanguage = media.originalLanguage
        
        if let path = media.posterPath {
            let cacheKey = NSString(string: path)
            if let image = TMDBClient.shared.cache.object(forKey: cacheKey) {
                mediaToSave.poster = image.pngData()
                saveContext(successful: successful)
                return
            }
            
            TMDBClient.shared.downloadPosterImage(path: path) {[weak self] image in
                guard let self = self else { return }
                mediaToSave.poster = image?.pngData()
                self.saveContext(successful: successful)
            }
        } else {
            mediaToSave.poster = media.posterData
            saveContext(successful: successful)
        }
    }
    
}
