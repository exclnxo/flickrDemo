//
//  FlickerApiService.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/25.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import Foundation
import Moya

enum ApiService {
    case fetchFlicker(text: String,page: String)
}

extension ApiService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=97eb73dd58fca7c770232514c19f6839&format=json&nojsoncallback=1")!
    }
    
    var path: String {
        switch self {
        case .fetchFlicker(let text, let page):
            print("api: \(text),\(page)")
            return ""
//            return "&text=\(text)&per_page=\(page)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .fetchFlicker(let text, let page):
            print("api1: \(text),\(page)")
//            return .requestPlain
            return .requestParameters(parameters: ["text": text.urlEscaped, "per_page": page.urlEscaped], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

extension String {
  var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

import RxSwift

class API {
    static let shared = API()
    
    let provider = MoyaProvider<ApiService>()
    
    func fetchPhoto(text: String, page: String) -> Single<Response> {
        return self.provider.rx.request(.fetchFlicker(text: text.lowercased(), page: page.lowercased()))
    }
}
