//
//  PhotoViewModel.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/28.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import RxSwift
import RxCocoa

class PhotoViewModel {
    
    let anchorArr = BehaviorRelay(value: [PhotoModel]())
    var disposBag = DisposeBag()
    let section: Observable<[PhotoSection]>
    let api = API.shared
    
    init() {
        
        section = anchorArr.asObservable().map { (models) -> [PhotoSection] in
            return [PhotoSection(header: "", items: models)]
        }.catchErrorJustReturn([])
    }
    
    func getPhoto(searchText: String, page: String) {
        api.fetchPhoto(text: searchText, page: page)
        .filterSuccessfulStatusCodes()
            .map(FlickerModel.self)
            .subscribe(onSuccess: { (p) in
            self.anchorArr.accept(p.photos.photo)
        }) { (e) in
            
        }.disposed(by: self.disposBag)
    }
}
