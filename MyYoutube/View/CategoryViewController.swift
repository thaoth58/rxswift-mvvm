//
//  CategoryViewController.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/24/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let viewModel = ListViewModel()
    let refreshControl = UIRefreshControl()
    var videos = [Video]()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bind()
        viewModel.fetchVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Config View
    func configView() {
        let categoryCellNib = UINib(nibName: CategoryCell.Identifier, bundle: nil)
        collectionView.register(categoryCellNib, forCellWithReuseIdentifier: CategoryCell.Identifier)
        
        refreshControl.addTarget(self, action: #selector(ListViewController.doRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        searchTextField
            .rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (query) in
                self.viewModel.searchText.onNext(query)
                self.doReloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func doRefresh() {
        viewModel.fetchVideo()
    }
    
    func doReloadData() {
        videos.removeAll()
        collectionView.reloadData()
        refreshControl.beginRefreshing()
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)
        viewModel.fetchVideo()
    }
    
    // MARK: - Binding view model
    private func bind() {
        viewModel.videos.bind { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind { (isLoading) in
            if !isLoading {
                self.refreshControl.endRefreshing()
            }
            }.disposed(by: disposeBag)
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.Identifier, for: indexPath) as! CategoryCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = (collectionView.frame.width / 2) - 10
        let heightItem = (widthItem * 3/4) + 72
        return CGSize(width: widthItem, height: heightItem)
    }
}
