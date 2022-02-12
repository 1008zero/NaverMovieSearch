//
//  SearchHistoryTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/26.
//

import UIKit
import RealmSwift
import SnapKit

class SearchHistoryTableViewCell: UITableViewCell {
    let realm = try! Realm()
    
    var index = 0
    let searchHistoryLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        return label
    }()
    
    let delBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        btn.addTarget(self, action: #selector(delData), for: .touchUpInside)
        return btn
    }()
    
    @objc func delData(sender: UIButton!) {
        try! realm.write{
            realm.delete(realm.objects(SearchHistory.self)[index])
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let safeArea = contentView.safeAreaLayoutGuide
        contentView.addSubview(searchHistoryLabel)
        searchHistoryLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(safeArea)
            make.left.equalTo(safeArea).offset(5)
        }
        
        contentView.addSubview(delBtn)
        delBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(safeArea)
            make.left.equalTo(searchHistoryLabel.snp.right).offset(5)
            make.right.equalTo(safeArea)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
