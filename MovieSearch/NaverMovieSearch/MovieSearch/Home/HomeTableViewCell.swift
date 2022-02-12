//
//  HomeTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    var movies = [Item]()
    
    let HomeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionview
    }()
    
    let HomeCellLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    var contentURL = ""
    
    
    override func layoutSubviews() {
        NetworkingNaver()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        let safeArea = contentView.safeAreaLayoutGuide
        contentView.addSubview(HomeCellLabel)
        HomeCellLabel.translatesAutoresizingMaskIntoConstraints = false
        HomeCellLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 5).isActive = true
        HomeCellLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 5).isActive = true
        HomeCellLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        HomeCellLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentView.addSubview(HomeCollectionView)
        HomeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        HomeCollectionView.topAnchor.constraint(equalTo: HomeCellLabel.bottomAnchor,constant: 5).isActive = true
        HomeCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        HomeCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        HomeCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        HomeCollectionView.delegate = self
        HomeCollectionView.dataSource = self
        HomeCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "ColletionCell")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func NetworkingNaver() {
        let clientID = "GIvL7QRvByOrQtoc30QG"
        let clientKEY = "lMhmbkwQH2"
        
        guard let url = URL(string: contentURL) else { print("url error"); return }
        
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
                self.movies = decodeData.items
                DispatchQueue.main.async {
                    self.HomeCollectionView.reloadData()
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


// MARK: - collectionView extension

extension HomeTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColletionCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        colCell.indicator.startAnimating()
        if let imgaeURL = URL(string: movies[indexPath.row].image) {
            let imageData = try! Data(contentsOf: imgaeURL)
            let cellImageData = UIImage(data: imageData)
            DispatchQueue.main.async {
                colCell.colCellImageView.image = cellImageData
                colCell.indicator.stopAnimating()
            }
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
    
    let indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func layoutSubviews() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        addSubview(colCellImageView)
        colCellImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        colCellImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        colCellImageView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        colCellImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        colCellImageView.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: colCellImageView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: colCellImageView.centerYAnchor).isActive = true
    }
}
