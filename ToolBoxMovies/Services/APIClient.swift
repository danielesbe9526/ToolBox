//
//  APIClient.swift
//  ToolBox
//
//  Created by Usuario1 on 12/7/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import Foundation
import Alamofire

enum APIError  {
    case connectionError(Error)
    case authorizationError(Error)
    case serverError(Error)
    case clientError(Error)
    case requestError(Error)
    case decodeError(Error)
}

enum Response<Value> {
    case succes(Value)
    case failure(APIError)
}

protocol APIClientProtocol {
    func obtainToken(completion: @escaping (Response<TokenModel>) -> Void)
    func obtainMovies(token: String, completion: @escaping (Response<Movies>) -> Void)
    func downloadImages(with url: URL, completion: @escaping (Response<UIImage>) -> Void)
}

final class APIClient: APIClientProtocol {

    let sessionManager = SessionManager()
    
    func obtainToken(completion: @escaping (Response<TokenModel>) -> Void) {
        
        sessionManager.request("https://echo-serv.tbxnet.com/v1/mobile/auth", method: .post, parameters: ["sub":"ToolboxMobileTest"], encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (jsonResponse) in
                if let error = jsonResponse.error {
                    completion(.failure(.requestError(error)))
                } else if let data = jsonResponse.data {
                    let decode = JSONDecoder()
                    
                    do {
                        let tokenInfo = try decode.decode(TokenModel.self, from: data)
                        completion(.succes(tokenInfo))
                    } catch {
                        completion(.failure(.decodeError(error)))
                    }
                }
        }
    }
    
    func obtainMovies(token: String, completion: @escaping (Response<Movies>) -> Void) {
        let headers = [
            "Authorization": "Bearer "+token
        ]
        
        sessionManager.request("https://echo-serv.tbxnet.com/v1/mobile/data/", method: .get, headers: headers).responseJSON { (response) in
            if let error = response.error {
                completion(.failure(.serverError(error)))
            } else if let data = response.data {
                let decode = JSONDecoder()
                
                do {
                    let movies = try decode.decode(Movies.self, from: data)
                    completion(.succes(movies))
                } catch {
                    completion(.failure(.decodeError(error)))
                }
            }
        }
    }
    
    func downloadImages(with url: URL, completion: @escaping ((Response<UIImage>) -> Void)) {
        
        sessionManager.request(url)
            .validate(statusCode: 200..<300)
            .response { (response) in
                if let error = response.error {
                    completion(.failure(.requestError(error)))
                } else if let data = response.data, let image = UIImage(data: data) {
                    completion(.succes(image))
                }
        }
     }
}

