//
//  HoemViewController.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit


class HomeViewController: UIViewController {
    
    let HomeLabel : UILabel = {
        let homelabel = UILabel()
        homelabel.text = "Movies"
        homelabel.font = UIFont.systemFont(ofSize: CGFloat(23))
        return homelabel
    }()
    let tableView : UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(HomeLabel)
        HomeLabel.translatesAutoresizingMaskIntoConstraints = false
        HomeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        HomeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 10).isActive = true
        HomeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: HomeLabel.bottomAnchor,constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
        self.tableView.rowHeight = view.frame.height / 5
    }
    

}

extension HomeViewController : UITableViewDelegate {

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.HomeCellLabel.text = "해리포터 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%ED%95%B4%EB%A6%AC%ED%8F%AC%ED%84%B0&display=10&start=1&country=GB"
        case 1:
            cell.HomeCellLabel.text = "스파이더맨 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%EC%8A%A4%ED%8C%8C%EC%9D%B4%EB%8D%94%EB%A7%A8&display=10&start=1"
        case 2:
            cell.HomeCellLabel.text = "쏘우 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%EC%8F%98%EC%9A%B0&display=10&start=1&genre=4&country=US"
        case 3:
            cell.HomeCellLabel.text = "레지던트 이블 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%EB%A0%88%EC%A7%80%EB%8D%98%ED%8A%B8%EC%9D%B4%EB%B8%94&display=10&start=1&country=US"
        case 4:
            cell.HomeCellLabel.text = "캐리비안의 해적 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%EC%BA%90%EB%A6%AC%EB%B9%84%EC%95%88%EC%9D%98%ED%95%B4%EC%A0%81&display=6&start=2"
        default:
            cell.HomeCellLabel.text = "헝거게임 시리즈"
            cell.contentURL = "https://openapi.naver.com/v1/search/movie.json?query=%ED%97%9D%EA%B1%B0%20%EA%B2%8C%EC%9E%84&display=5&start=1"
        }
        
        return cell
    }

}


