//
//  HoemViewController.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let linkArray = [
        "https://openapi.naver.com/v1/search/movie.json?query=%ED%95%B4%EB%A6%AC%ED%8F%AC%ED%84%B0&display=10&start=1&country=GB",
        "https://openapi.naver.com/v1/search/movie.json?query=%EC%8F%98%EC%9A%B0&display=10&start=1&genre=4&country=US",
        "https://openapi.naver.com/v1/search/movie.json?query=%EC%BA%90%EB%A6%AC%EB%B9%84%EC%95%88%EC%9D%98%ED%95%B4%EC%A0%81&display=6&start=2",
        "https://openapi.naver.com/v1/search/movie.json?query=%ED%97%9D%EA%B1%B0%20%EA%B2%8C%EC%9E%84&display=5&start=1",
        "https://openapi.naver.com/v1/search/movie.json?query=%EC%8A%A4%ED%8C%8C%EC%9D%B4%EB%8D%94%EB%A7%A8&display=10&start=1",
        "https://openapi.naver.com/v1/search/movie.json?query=%EB%A0%88%EC%A7%80%EB%8D%98%ED%8A%B8%EC%9D%B4%EB%B8%94&display=10&start=1&country=US"
    ]
    
    let titleArray = [
        "해리포터 시리즈",
        "쏘우 시리즈",
        "캐리비안의 해적 시리즈",
        "헝거게임 시리즈",
        "스파이더맨 시리즈",
        "레지던트 이블 시리즈",
    ]
    
    let HomeLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValue()
        setUpView()
        setConstraints()
    }
    
    private func setUpValue(){
        HomeLabel.text = "Movies"
        HomeLabel.font = UIFont.systemFont(ofSize: CGFloat(23))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
        self.tableView.rowHeight = view.frame.height / 5
    }
    
    private func setUpView(){
        self.view.addSubview(HomeLabel)
        self.view.addSubview(tableView)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        HomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(safeArea).offset(10)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(HomeLabel.snp.bottom).offset(5)
            make.left.equalTo(safeArea)
            make.right.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
        }
    }

}

extension HomeViewController : UITableViewDelegate {

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.HomeCellLabel.text = titleArray[indexPath.row]
        cell.contentURL = linkArray[indexPath.row]
        cell.NetworkingNaver() {print($0)}
        return cell
    }

}


