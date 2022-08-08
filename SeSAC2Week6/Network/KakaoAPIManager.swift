//
//  KakaoAPIManager.swift
//  SeSAC2Week6
//
//  Created by Carki on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

//이 클래스의 싱글턴 패턴 분석하기
class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() {  }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandelr: @escaping (JSON) -> () ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        var url = type.requestURL + query
        
//        var url = blogURL + keyWord
        
        //Alamofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let Json = json
                completionHandelr(json)
                
                //블로그에 갱신 코드가 필요없는 이유
                // >>데이터를 다 받고나서 한번에 갱신하는게 효율적인거같아서
                //갱신 코드는 나중에 실행될 코드 ( 여기서는 리퀘스트 카페) 에서 실행하는게 효율적이다.
                
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
}
