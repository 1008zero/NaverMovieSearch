//
//  SearchViewController.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    let realm = try! Realm()
    var Datas : Results<SearchHistory>?
    var notiToken : NotificationToken?
    
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let safeArea = view.safeAreaLayoutGuide
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "찾으시는 영화를 입력하세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Movie Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        
    }
    
    func SearchMovie(_ qurry : String) {
        var baseUrl = "https://openapi.naver.com/v1/search/movie.json?query="
        baseUrl += qurry
        let clientID = "GIvL7QRvByOrQtoc30QG"
        let clientKEY = "lMhmbkwQH2"
        let encodedString = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: encodedString) else { print("url error"); return }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-ID")
        request.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let dataTask = session.dataTask(with: request) { (data, respone, error) in
            guard error == nil else { return }
            
            let successRange = 200..<300
            guard let statusCode = (respone as? HTTPURLResponse)?.statusCode,successRange.contains(statusCode) else { return }
            
            guard let resultData = data else { return }
           
            do {
                let decodeData = try JSONDecoder().decode(SearchData.self, from: resultData)
                SearchData2.items = decodeData.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    func loadWeb(_ link : String) {
        guard let url = URL(string: "\(link)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    

}
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

            cell.indicator.startAnimating()
            if let imgaeURL = URL(string: SearchData2.items[indexPath.row].image) {
                let imageData = try! Data(contentsOf: imgaeURL)
                let cellImageData = UIImage(data: imageData)
                DispatchQueue.main.async {
                    var str = SearchData2.items[indexPath.row].title.replacingOccurrences(of: "<b>", with: "")
                    str = str.replacingOccurrences(of: "</b>", with: "")
                    cell.resultTilteLabel.text = str
                    let artStr = NSMutableAttributedString(string: cell.resultTilteLabel.text!)
                    artStr.addAttribute(.backgroundColor, value: UIColor.yellow, range: (cell.resultTilteLabel.text! as NSString).range(of: SearchData2.texts))
                    cell.resultTilteLabel.attributedText = artStr
                    
                    cell.resultRateLabel2.text = SearchData2.items[indexPath.row].userRating
                    cell.resultdirectorLabel2.text = SearchData2.items[indexPath.row].director
                    cell.resultActorLabel2.text = SearchData2.items[indexPath.row].actor
                    cell.resultImageView.image = cellImageData
                    cell.indicator.stopAnimating()
                }
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
        SearchMovie(text)
        SearchData2.texts = text
    }
    
    
}
