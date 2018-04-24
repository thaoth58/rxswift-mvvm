//
//  ListViewController.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/21/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        let videoCellNib = UINib(nibName: VideoCell.Identifier, bundle: nil)
        tableView.register(videoCellNib, forCellReuseIdentifier: VideoCell.Identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        refreshControl.addTarget(self, action: #selector(ListViewController.doRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        searchBar.delegate = self
        searchBar
            .rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
//        searchBar
//            .rx.text
//            .orEmpty
//            .debounce(0.3, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { (query) in
//                self.viewModel.searchText.onNext(query)
//                self.doReloadData()
//            })
//            .disposed(by: disposeBag)
    }
    
    @objc func doRefresh() {
        viewModel.fetchVideo()
    }
    
    func doReloadData() {
        videos.removeAll()
        tableView.reloadData()
        refreshControl.beginRefreshing()
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)
        viewModel.fetchVideo()
    }
    
    // MARK: - Binding view model
    private func bind() {
        viewModel.videos.bind { (videos) in
            self.videos = videos
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind { (isLoading) in
            if !isLoading {
                self.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.Identifier, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doReloadData()
    }
}
