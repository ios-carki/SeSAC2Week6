//
//  URL+Extension.swift
//  SeSAC2Week6
//
//  Created by Carki on 2022/08/08.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    //베이스 url 변수 뒤에 완벽한 URL을 완성하기 위함
    static func makeEndPointString(_ endpoint: String) -> String {
        
        return baseURL + endpoint
    }
}
