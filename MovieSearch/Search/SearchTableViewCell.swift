//
//  SearchTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit
import SnapKit


class SearchTableViewCell: UITableViewCell {

    let resultImageView = UIImageView()
    let resultTilteLabel = UILabel()
    let resultRateLabel = UILabel()
    let resultRateLabel2 = UILabel()
    let resultdirectorLabel = UILabel()
    let resultdirectorLabel2 = UILabel()
    let resultActorLabel = UILabel()
    let resultActorLabel2 = UILabel()
    let indicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setValue()
        setUpView()
        setConstraints()
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
// MARK: - func
    private func setValue() {
        resultImageView.contentMode = .scaleToFill
        resultTilteLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        resultTilteLabel.allowsDefaultTighteningForTruncation = true
        resultRateLabel.text = "평점"
        resultRateLabel2.font = UIFont.systemFont(ofSize: CGFloat(20))
        resultRateLabel2.textColor = .red
        resultdirectorLabel.text = "감독"
        resultActorLabel.text = "출연 배우"
    }
    private func setUpView() {
        contentView.addSubview(resultImageView)
        contentView.addSubview(resultTilteLabel)
        contentView.addSubview(resultRateLabel)
        contentView.addSubview(resultdirectorLabel)
        contentView.addSubview(resultActorLabel)
        contentView.addSubview(resultRateLabel2)
        contentView.addSubview(resultdirectorLabel2)
        contentView.addSubview(resultActorLabel2)
        resultImageView.addSubview(indicator)
    }
    private func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        resultImageView.snp.makeConstraints{ make in
            make.top.equalTo(safeArea).offset(5)
            make.left.equalTo(safeArea).offset(5)
            make.bottom.equalTo(safeArea).offset(-5)
            make.width.equalTo(110)
        }
        
        resultTilteLabel.snp.makeConstraints{ make in
            make.top.equalTo(safeArea).offset(5)
            make.left.equalTo(resultImageView.snp.right).offset(5)
            make.right.equalTo(safeArea).offset(-5)
        }
        
        resultRateLabel.snp.makeConstraints{ make in
            make.top.equalTo(resultTilteLabel.snp.bottom).offset(15)
            make.left.equalTo(resultImageView.snp.right).offset(5)
        }
        
        resultdirectorLabel.snp.makeConstraints { make in
            make.top.equalTo(resultRateLabel.snp.bottom).offset(10)
            make.left.equalTo(resultImageView.snp.right).offset(5)
        }
        
        resultActorLabel.snp.makeConstraints{ make in
            make.top.equalTo(resultdirectorLabel.snp.bottom).offset(10)
            make.left.equalTo(resultImageView.snp.right).offset(5)
        }
        
        resultRateLabel2.snp.makeConstraints{ make in
            make.top.equalTo(resultTilteLabel.snp.bottom).offset(11)
            make.left.equalTo(resultdirectorLabel.snp.right).offset(5)
        }
        
        resultdirectorLabel2.snp.makeConstraints{ make in
            make.top.equalTo(resultRateLabel2.snp.bottom).offset(10)
            make.left.equalTo(resultdirectorLabel.snp.right).offset(5)
        }
        
        resultActorLabel2.snp.makeConstraints{ make in
            make.top.equalTo(resultdirectorLabel2.snp.bottom).offset(10)
            make.left.equalTo(resultActorLabel.snp.right).offset(5)
            make.right.equalTo(safeArea).offset(-5)
        }
        
        indicator.snp.makeConstraints{ make in
            make.center.equalTo(resultImageView)
        }
    }

}
