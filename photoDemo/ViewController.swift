//
//  ViewController.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/23.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var searachTextfield: UITextField =  {
        var tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "欲搜尋內容"
        return tf
    }()
    
    var pageTextfield: UITextField =  {
        var tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "每頁呈現數量"
        return tf
    }()
    
    var searchBtn: UIButton = {
        var b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("搜尋", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = UIColor.gray
        b.isEnabled = false
        return b
    }()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        bindUI()
        
    }
    
    func setupUI() {
        self.title = "搜尋輸入頁"
        view.backgroundColor = UIColor.white
        view.addSubview(self.searachTextfield)
        view.addSubview(self.pageTextfield)
        view.addSubview(self.searchBtn)
        
        NSLayoutConstraint.activate([
            self.searachTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searachTextfield.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.searachTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.searachTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            self.pageTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pageTextfield.topAnchor.constraint(equalTo: self.searachTextfield.bottomAnchor, constant: 50),
            self.pageTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.pageTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            self.searchBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchBtn.topAnchor.constraint(equalTo: self.pageTextfield.bottomAnchor, constant: 50),
            self.searchBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.searchBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
        ])
        
    }
    
    func bindUI() {
        let viewModel = ViewModel(input: (searchText: self.searachTextfield.rx.text.orEmpty.asObservable(),
                                          searchPage: self.pageTextfield.rx.text.orEmpty.asObservable(),
                                          searchTaps: self.searchBtn.rx.tap.asObservable()))
        
        viewModel.canSearch.asObservable()
            .subscribe(onNext: { (enable) in
                self.searchBtn.backgroundColor = enable ? UIColor.blue : UIColor.gray
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        viewModel.canSearch
            .bind(to: searchBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        let relay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let page = BehaviorRelay<String>(value: "")
        
        searachTextfield.rx.text.asObservable().subscribe(onNext: { (s) in
            print("s: \(s)")
            if s != nil {
                relay.accept(s!)
            }
        }).disposed(by: disposeBag)
        
        pageTextfield.rx.text.asObservable().subscribe(onNext: { (s) in
            print("s: \(s)")
            if s != nil {
                page.accept(s!)
            }
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(onNext: { recognizer in
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        self.searchBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = PhotoTabBarController()
                vc.modalPresentationStyle = .fullScreen
                
                let photoVC = PhotoViewController(text: relay.value, page: page.value)
                photoVC.tabBarItem.image = .strokedCheckmark
                photoVC.tabBarItem.title = "photo"
                
                vc.viewControllers = [photoVC]
                vc.selectedIndex = 0
                
                self?.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
}

