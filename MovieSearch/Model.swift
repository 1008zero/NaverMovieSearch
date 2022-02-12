//
//  model.swift
//  MovieSearch
//
//  Created by Ki Hyun on 2022/01/25.
//
// 1.realm으로 검색바의 텍스트가 비어있다면 검색했던것들 나오기 (클릭하면 주소 이동) ㅇ
// 2.네트워킹해서 받아온 데이터에서 <b> 이거 지우기 ㅇ
// 3.알라모파이어 ㅇ
// 4.이미지 캐싱 (금방 하는 거라 아직) ㅇ
// 5.스냅킷 ㅇ
// 6.클린 하게 코드짜기 (내 생각 50%함) o
// 7.화면클릭하면 키보드, 서치바 비활성화, 서치바에서 x누르면 텍스트 전부 지워지게 끔 o

import Foundation
import RealmSwift

// MARK: - SearchData
struct SearchData: Codable {
    let items: [Item]
}

// MARK: - SearchData2
struct SearchData2 {
    static var items = [Item]()
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

// MARK: - Realm
class SearchHistory : Object {
    @objc dynamic var HistoryText = ""
    @objc dynamic var Link = ""
}
