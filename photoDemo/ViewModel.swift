//
//  ViewModel.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/26.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import RxSwift
import RxCocoa

class ViewModel {
    
    let validText: Observable<Bool>
    let validPage: Observable<Bool>
    let canSearch: Observable<Bool>
    
    init(input: (
            searchText: Observable<String>,
            searchPage: Observable<String>,
            searchTaps: Observable<Void>
        )
    ) {
        
        validText = input.searchText
        .map { $0.count > 0 }
        .share(replay: 1)
        
        validPage = input.searchPage
        .map { $0.count > 0 }
        .share(replay: 1)

        canSearch = Observable.combineLatest(validText, validPage){
            text, validPage in
            text == true && validPage == true
        }
        .distinctUntilChanged()
        .share(replay: 1)
    }
}
