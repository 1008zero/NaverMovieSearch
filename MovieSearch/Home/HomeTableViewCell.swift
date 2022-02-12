//
//  HomeTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    var movies = [Item]()
    var contentURL = ""
    
    
    let HomeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionview
    }()
    let HomeCellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpValue()
        setUpView()
        setConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

// MARK: - func
    private func setUpValue() {
        HomeCollectionView.delegate = self
        HomeCollectionView.dataSource = self
        HomeCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "ColletionCell")
        
        HomeCellLabel.text = ""
    }
    
    private func setUpView() {
        self.contentView.addSubview(HomeCellLabel)
        self.contentView.addSubview(HomeCollectionView)
    }
    
    private func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        HomeCellLabel.snp.makeConstraints { make in
            make.left.equalTo(safeArea).offset(5)
            make.top.equalTo(safeArea).offset(5)
            make.height.equalTo(25)
            make.width.equalTo(200)
        }
        
        HomeCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(HomeCellLabel.snp.bottom).offset(5)
            make.left.equalTo(safeArea)
            make.right.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
        }
    }
    public func NetworkingNaver(completion: @escaping (Result<Any,Error>) -> ()){
        let headers: HTTPHeaders = [ "X-Naver-Client-Id": "GIvL7QRvByOrQtoc30QG", "X-Naver-Client-Secret": "lMhmbkwQH2"]
        AF.request(contentURL,headers: headers)
            .responseData { (response) in
                switch response.result{
                case let .success(resultData):
                    do {
                        let decodeData = try JSONDecoder().decode(SearchData.self, from: resultData)
                        completion(.success(decodeData))
                        self.movies = decodeData.items
                        self.reloadTable()
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    private func loadWeb(_ link : String) {
        guard let url = URL(string: "\(link)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func reloadTable(){
        DispatchQueue.main.async {
            self.HomeCollectionView.reloadData()
        }
    }
}


// MARK: - collectionView extension

extension HomeTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColletionCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        colCell.colCellImageView.kf.indicatorType = .activity
        DispatchQueue.main.async {
            let imgaeURL = URL(string: self.movies[indexPath.row].image)
            colCell.colCellImageView.kf.setImage(with: imgaeURL)
        }
        return colCell
    }
    
    
}

extension HomeTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadWeb(movies[indexPath.row].link)
    }
}

extension HomeTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height - 20
        return CGSize(width: size - 20, height: size)
    }
}



// MARK: - CollectionViewCell

class HomeCollectionViewCell : UICollectionViewCell {
    let colCellImageView : UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleToFill
        
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let safeArea = self.contentView.safeAreaLayoutGuide
        contentView.addSubview(colCellImageView)
        colCellImageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.left.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.right.equalTo(safeArea)
        }
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
