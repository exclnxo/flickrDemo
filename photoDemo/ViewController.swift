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
        
        let results = searachTextfield.rx.text
        .throttle(0.3, scheduler: MainScheduler.instance)

        results.bind(to: searachTextfield.rx.text).disposed(by: disposeBag)
        
        let searchVaild = self.searachTextfield.rx.text.orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let pageVaild = self.pageTextfield.rx.text.orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(searchVaild, pageVaild) { $0 && $1}.share(replay: 1)
        
        everythingValid.bind(to: self.searchBtn.rx.isEnabled).disposed(by: disposeBag)
        
        everythingValid.subscribe(onNext: { (vaild) in
            self.searchBtn.backgroundColor = vaild ? UIColor.blue : UIColor.gray
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
                //                photoVC.searchText = t
                //                photoVC.searchPage = p
                                
                                vc.viewControllers = [photoVC]
                vc.selectedIndex = 0
                
            print("relay: \(relay.value)")
//                vc.readyText(t: relay.value, p: page.value)
                self?.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "tap", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: false, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
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

}

