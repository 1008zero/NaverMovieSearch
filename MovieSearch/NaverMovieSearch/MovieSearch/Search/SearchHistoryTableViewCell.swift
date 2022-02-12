//
//  SearchHistoryTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/26.
//

import UIKit
import RealmSwift

class SearchHistoryTableViewCell: UITableViewCell {
    let realm = try! Realm()
    
    var index = 0
    let searchHistoryLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let delBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(delData), for: .touchUpInside)
        return btn
    }()
    
    @objc func delData(sender: UIButton!) {
        try! realm.write{
            realm.delete(realm.objects(SearchHistory.self)[index])
        }
    }
    
    override func layoutSubviews() {
        let safeArea = contentView.safeAreaLayoutGuide
        contentView.addSubview(searchHistoryLabel)
        searchHistoryLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        searchHistoryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 5).isActive = true
        
        contentView.addSubview(delBtn)
        delBtn.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        delBtn.leadingAnchor.constraint(equalTo: searchHistoryLabel.trailingAnchor,constant: 5).isActive = true
        delBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        delBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        delBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
