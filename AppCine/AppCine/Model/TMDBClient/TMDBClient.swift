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
    
    
    func searchBy(movie query: String, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask {
        return taskForGetRequest(url: Endpoints.searchByMovie(query).url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
            guard let _ = self else { return }
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            DispatchQueue.main.async { completion(.success(response!.results)) }
        }
    }
    
    
    func searchBy(tvShow query: String, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask {
        return taskForGetRequest(url: Endpoints.searchByTvShow(query).url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
            guard let _ = self else { return }
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            DispatchQueue.main.async { completion(.success(response!.results)) }
        }
    }
    
    
    func getPopularsMedia(url: URL, completion: @escaping(Result<[ACMedia], Error>)->Void) -> URLSessionTask {
        return taskForGetRequest(url: url, responseType: TMDBResponse<ACMedia>.self) {[weak self] response, error in
            guard let _ = self else { return }
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            DispatchQueue.main.async { completion(.success(response!.results)) }
        }
    }
    
    
    func downloadPosterImage(path: String, completion: @escaping(UIImage?)->Void) {
        let cacheKey = NSString(string: path)
        if let image = TMDBClient.shared.cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { completion(image) }; return
        }
        
        URLSession.shared.dataTask(with: Endpoints.posterImageUrl(path).url) {[weak self] data, response, error in
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
    }
    
}
