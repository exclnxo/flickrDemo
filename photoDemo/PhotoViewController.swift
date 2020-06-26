//
//  PhotoViewController.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/25.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxDataSources
import Kingfisher

class PhotoViewController: UIViewController {
    
    var collectionView: UICollectionView?
    
    var text: String?
    var page: String?
    var searchText = BehaviorRelay<String>(value: "")
    var searchPage: String?
    
    let provider = MoyaProvider<ApiService>()
    var disposBag = DisposeBag()
    
    let anchorArr = BehaviorRelay(value: [PhotoModel]())
    
    init(text: String,page: String) {
        super.init(nibName: nil, bundle: nil)
        self.text = text
        self.page = page
        print("relay2: \(text),\(self.text)")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 10) / 2
        layout.itemSize = CGSize(width: width, height: width + 80)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photo")
        self.view.addSubview(collectionView!)
        
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func fetchPhoto(text: String) {
        print("searchText3: \(text)")
        searchText.accept(text)
    }
    
    func bindUI() {
        
        self.provider.rx.request(.fetchFlicker(text: self.text!.lowercased(), page: self.page!.lowercased()))
            .filterSuccessfulStatusCodes()
            .map(FlickerModel.self)
            .subscribe(onSuccess: { (p) in
                self.anchorArr.accept(p.photos.photo)
                //                print(p.photos.photo.first)
            }) { (e) in
                print(e)
                self.showAlert(title: e.localizedDescription)
        }.disposed(by: self.disposBag)
        
        
        let sections = anchorArr.asObservable().map { (models) -> [PhotoSection] in
            return [PhotoSection(header: "", items: models)]
        }.asObservable().catchErrorJustReturn([])
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PhotoSection>(configureCell: { (dataSorce, collectionView, indexPath, element) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as! PhotoCell
            cell.label.text = element.title
            cell.iv.kf.setImage(with: element.imageUrl)
            return cell
        })
        
        sections
            .bind(to: (collectionView?.rx.items(dataSource: dataSource))!)
            .disposed(by: disposBag)
    }
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: false, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

struct PhotoSection: SectionModelType {
    var header: String
    var items: [PhotoModel]
}

extension PhotoSection {
    typealias Item = PhotoModel
    
    var identity: String {
        return header
    }
    
    init(original: PhotoSection, items: [PhotoModel]) {
        self = original
        self.items = items
    }
}
