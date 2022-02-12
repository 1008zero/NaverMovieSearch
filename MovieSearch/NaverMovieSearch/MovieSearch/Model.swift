//
//  model.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//
// 1.realm으로 검색바의 텍스트가 비어있다면 검색했던것들 나오기 (클릭하면 주소 이동) ㅇ
// 2.정규표현식으로 <> 이거 지우기 ㅇ
// 3.알라모파이어 ㅇ
// 4.이미지 캐싱
// 5.스냅킷
// 6.클린 하게 코드짜기
// 7.가능하다면 오퍼레이션 큐로 취소처리도 해보기

import Foundation
import RealmSwift

// MARK: - SearchData
struct SearchData: Codable {
    let items: [Item]
}

// MARK: - SearchData2
struct SearchData2 {
    static var items = [Item]()
    static var filterItems = [Item]()
    static var texts : String = ""
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle, pubDate, director, actor: String
    let userRating: String
}

class SearchHistory : Object {
    @objc dynamic var HistoryText = ""
    @objc dynamic var Link = ""
}
