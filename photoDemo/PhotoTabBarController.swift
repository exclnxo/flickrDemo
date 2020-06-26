//
//  PhotoTabBarController.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/25.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoTabBarController: UITabBarController {

//    var searchText: String?
//    var searchPage: String?
//
//    var repo = BehaviorRelay<String>(value: "")
//    var disposeBag =  DisposeBag()
//
//    init(text: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.searchText = text
//        print("relay1: \(text),\(self.searchText)")
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        self.title = "Phtoo"
//
//
//
//        let photoVC = PhotoViewController(text: self.searchText ?? "")
//                        photoVC.tabBarItem.image = .strokedCheckmark
//                        photoVC.tabBarItem.title = "photo"
//        //                photoVC.searchText = t
//        //                photoVC.searchPage = p
//
//                        self.viewControllers = [photoVC]
//
//        self.selectedIndex = 0
//
////        repo.asObservable().subscribe(onNext: { (s) in
////            print("searchText2: \(s)")
////            if !s.isEmpty {
////                photoVC.fetchPhoto(text: s)
////            }
////        }, onError: nil, onCompleted: nil, onDisposed: nil)
////        .disposed(by: disposeBag)
//    }
//
//    func readyText(t: String, p: String) {
//        print("searchText1: \(t)")
//        
//        repo.accept(t)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
