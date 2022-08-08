//
//  ViewController.swift
//  SeSAC2Week6
//
//  Created by Carki on 2022/08/08.
//

import UIKit

import SwiftyJSON
/*
 1.html tag <> </> 기능 활용
 2.문자열 대체 메서드
 * response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는!?
 */

/*
  TableView automaticDimension
  - 컨텐츠 양에 따라서 셀 높이가 자유롭게
  - 조건1: 레이블 numberOfLines 0
  - 조건2: tableView Height automaticDimension
  - 조건3: 레이아웃
 */
class ViewController: UIViewController {

    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false //false 2줄, true 0으로!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        searchBlog()
//        requestBlog(query: "고래밥") //블로그 요청 후에 카페 API 호출하고싶다면? => 세마포어???세마포 찾아보기!
        
    }
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
            print(json)
            
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue)
            }
            self.searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            print(json)
            
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                
                self.cafeList.append(value)
            }
            print(self.blogList)
            print(self.cafeList)
            
            self.tableView.reloadData()
            
        }
    }

    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
    //Alamofire + SwiftyJSON
    //검색 키워드
    //인증키
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else {
            return UITableViewCell()
        }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class kakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
}
