//
//  TMDBClient.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import Foundation
import UIKit


class TMDBClient {
    
    //MARK: - Properties
    static let shared = TMDBClient()
    
    let cache = NSCache<NSString, UIImage>()

    private init() {}    
    
    private func parseTMDBError(_ data: Data) -> Error {
        do { return try JSONDecoder().decode(TMDBError.self, from: data) } catch { return error }
    }
    
    private func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping(ResponseType?, Error?)->Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { completion(nil, error); return }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil, ACError.invalidResponse); return
            }
            
            guard let data = data else { completion(nil, ACError.invalidData); return }
            
            do {
                let response = try JSONDecoder().decode(ResponseType.self, from: data)
                completion(response, nil)
            } catch { completion(nil, self.parseTMDBError(data)) }
        }
        task.resume()
        return task
    }
    
    
    func searchBy(movie query: String, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask? {
        if let url = Endpoints.searchByMovie(query).url {
            return taskForGetRequest(url: url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
                guard let _ = self else { return }
                if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
                DispatchQueue.main.async { completion(.success(response!.results)) }
            }
        } else {
            DispatchQueue.main.async{ completion(.failure(ACError.invalidadUrl)) }
            return nil
        }
    }
    
    
    func searchBy(tvShow query: String, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask? {
        if let url = Endpoints.searchByTvShow(query).url {
            return taskForGetRequest(url: url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
                guard let _ = self else { return }
                if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
                DispatchQueue.main.async { completion(.success(response!.results)) }
            }
        } else {
            DispatchQueue.main.async{ completion(.failure(ACError.invalidadUrl)) }
            return nil
        }
        
    }
    
    
    func getPopularsMedia(url: URL?, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask? {
        if let url = url {
            return taskForGetRequest(url: url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
                guard let _ = self else { return }
                if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
                DispatchQueue.main.async { completion(.success(response!.results)) }
            }
        } else {
            DispatchQueue.main.async{ completion(.failure(ACError.invalidadUrl)) }
            return nil
        }
    }
    
    
    func getVideos(for type: MediaType, with id: String, completion: @escaping([ACVideo]?)->Void) {
        let mediaUrl = type == .movies ? Endpoints.getMovieVideos(id).url : Endpoints.getSerieVideos(id).url
        if let url = mediaUrl {
            let _ = taskForGetRequest(url: url, responseType: TMDBVideoResponse.self) {[weak self] response, error in
                guard let _ = self else { completion(nil); return }
                if let videos = response?.results, !videos.isEmpty {
                    DispatchQueue.main.async { completion(videos) }
                } else { DispatchQueue.main.async { completion(nil) } }
            }
        }
    }
    
    
    func downloadPosterImage(path: String, completion: @escaping(UIImage?)->Void) {
        let cacheKey = NSString(string: path)
        if let image = TMDBClient.shared.cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { completion(image) }; return
        }
        
        if let url = Endpoints.posterImageUrl(path).url {
            URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                guard let _ = self else { return }
                guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200, let data = data else {
                      DispatchQueue.main.async { completion(nil) }; return
                  }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        TMDBClient.shared.cache.setObject(image, forKey: cacheKey)
                        completion(image)
                    } else { completion(nil) }
                }
            }.resume()
        } else { DispatchQueue.main.async { completion(nil) } }
    }
    
}
