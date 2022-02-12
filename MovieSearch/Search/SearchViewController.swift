//
//  SearchViewController.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit
import RealmSwift
import Alamofire
import SnapKit
import Kingfisher

class SearchViewController: UIViewController {
    let realm = try! Realm()
    var Datas : Results<SearchHistory>?
    var notiToken : NotificationToken?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetnotiToken()
        setting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

// MARK: - func
    private func SearchMovie(_ qurry : String, completion: @escaping (Result<Any,Error>) -> ()){
        var urlString = "https://openapi.naver.com/v1/search/movie.json?query=\(qurry)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let headers: HTTPHeaders = [ "X-Naver-Client-Id": "GIvL7QRvByOrQtoc30QG", "X-Naver-Client-Secret": "lMhmbkwQH2"]
        AF.request(urlString,headers: headers)
            .responseData { (response) in
                switch response.result{
                case let .success(resultData):
                    do {
                        let decodeData = try JSONDecoder().decode(SearchData.self, from: resultData)
                        completion(.success(decodeData))
                        SearchData2.items = decodeData.items
                        self.reloadTable()
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    private func setting() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.left.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.right.equalTo(safeArea)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        searchController.searchBar.placeholder = "찾으시는 영화를 입력하세요."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Movie Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false

    }
    private func SetnotiToken(){
        Datas = realm.objects(SearchHistory.self)
        notiToken = Datas?.observe { [weak self] change in
            switch change {
            case .initial(_):
                self?.tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            }
        }
    }

    private func loadWeb(_ link : String) {
        guard let url = URL(string: "\(link)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - extension
extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SearchData2.texts == "" {
            return realm.objects(SearchHistory.self).count
        }
        return SearchData2.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if SearchData2.texts != "" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else {
                return UITableViewCell()
            }
//            DispatchQueue.main.async {
//                let imgaeURL = URL(string: self.movies[indexPath.row].image)
//                colCell.colCellImageView.kf.setImage(with: imgaeURL)
//                colCell.colCellImageView.kf.indicatorType = .activity
//            }

            DispatchQueue.main.async {
                cell.resultImageView.kf.indicatorType = .activity
                let imgaeURL = URL(string: SearchData2.items[indexPath.row].image)
                cell.resultImageView.kf.setImage(with: imgaeURL)
                var str = SearchData2.items[indexPath.row].title.replacingOccurrences(of: "<b>", with: "")
                str = str.replacingOccurrences(of: "</b>", with: "")
                str = str.replacingOccurrences(of: "&amp;", with: "")
                let artStr = NSMutableAttributedString(string: str)
                artStr.addAttribute(.backgroundColor, value: UIColor.yellow, range: (str as NSString).range(of: SearchData2.texts))
                cell.resultTilteLabel.attributedText = artStr
                
                cell.resultRateLabel2.text = SearchData2.items[indexPath.row].userRating
                cell.resultdirectorLabel2.text = SearchData2.items[indexPath.row].director
                cell.resultActorLabel2.text = SearchData2.items[indexPath.row].actor
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath) as? SearchHistoryTableViewCell else {
                return UITableViewCell()
        }
        cell.searchHistoryLabel.text = realm.objects(SearchHistory.self)[indexPath.row].HistoryText
        cell.index = indexPath.row
        return cell
    }
    
    
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //검색내용이 있을 경우
        if SearchData2.texts != "" {
            self.searchController.searchBar.searchTextField.resignFirstResponder()
            loadWeb(SearchData2.items[indexPath.row].link)
            let Data = SearchHistory()
            var str = SearchData2.items[indexPath.row].title.replacingOccurrences(of: "<b>", with: "")
            str = str.replacingOccurrences(of: "</b>", with: "")
            Data.HistoryText = str
            Data.Link = SearchData2.items[indexPath.row].link
            try! realm.write {
                realm.add(Data)
            }
        // 검색 내용이 없을 경우
        }else {
            loadWeb(realm.objects(SearchHistory.self)[indexPath.row].Link)
            self.searchController.searchBar.searchTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.tableView.rowHeight
        if SearchData2.texts == "" {
            height = view.frame.height / 15
        }else {
            height = view.frame.height / 6
        }
        return height
    }
}


extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else {
            SearchData2.texts = ""
            self.tableView.reloadData()
            return
        }
        let text = searchController.searchBar.text!
        SearchMovie(text){ print($0) }
        SearchData2.texts = text
    }
    
    
}


