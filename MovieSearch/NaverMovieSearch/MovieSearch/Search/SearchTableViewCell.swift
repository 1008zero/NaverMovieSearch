//
//  SearchTableViewCell.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    let resultImageView : UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resultTilteLabel : UILabel = {
        let label = UILabel()
        label.text = "dddddddddddd"
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultRateLabel : UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultRateLabel2 : UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.font = UIFont.systemFont(ofSize: CGFloat(20))
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultdirectorLabel : UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultdirectorLabel2 : UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultActorLabel : UILabel = {
        let label = UILabel()
        label.text = "출연 배우"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultActorLabel2 : UILabel = {
        let label = UILabel()
        label.text = "출연 배우"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func layoutSubviews() {
        let safeArea = contentView.safeAreaLayoutGuide
        contentView.addSubview(resultImageView)
        resultImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 5).isActive = true
        resultImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        resultImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true
        resultImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height - 30).isActive = true
        
        contentView.addSubview(resultTilteLabel)
        resultTilteLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 5).isActive = true
        resultTilteLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 5).isActive = true
        resultTilteLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 5).isActive = true
        
        contentView.addSubview(resultRateLabel)
        resultRateLabel.topAnchor.constraint(equalTo: resultTilteLabel.bottomAnchor, constant: 15).isActive = true
        resultRateLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(resultdirectorLabel)
        resultdirectorLabel.topAnchor.constraint(equalTo: resultRateLabel.bottomAnchor,constant: 10).isActive = true
        resultdirectorLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(resultActorLabel)
        resultActorLabel.topAnchor.constraint(equalTo: resultdirectorLabel.bottomAnchor,constant: 10).isActive = true
        resultActorLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(resultRateLabel2)
        resultRateLabel2.topAnchor.constraint(equalTo: resultTilteLabel.bottomAnchor, constant: 11).isActive = true
        resultRateLabel2.leadingAnchor.constraint(equalTo: resultRateLabel.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(resultdirectorLabel2)
        resultdirectorLabel2.topAnchor.constraint(equalTo: resultRateLabel2.bottomAnchor,constant: 10).isActive = true
        resultdirectorLabel2.leadingAnchor.constraint(equalTo: resultdirectorLabel.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(resultActorLabel2)
        resultActorLabel2.topAnchor.constraint(equalTo: resultdirectorLabel2.bottomAnchor,constant: 10).isActive = true
        resultActorLabel2.leadingAnchor.constraint(equalTo: resultActorLabel.trailingAnchor, constant: 5).isActive = true
        
        resultImageView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: resultImageView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: resultImageView.centerYAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
