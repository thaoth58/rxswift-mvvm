//
//  ListViewModel.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/21/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import RxSwift

class ListViewModel: NSObject {
    // MARK: - Public
    let searchText = BehaviorSubject<String>(value: "")
    var videos: Observable<[Video]> {
        return self.videosVariable.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return self.isLoadingVariable.asObservable()
    }
    
    func fetchVideo() {
        isLoadingVariable.onNext(true)
        do {
            let keySearch = try searchText.value()
            ApiProvider.getListVideo(keySearch: keySearch) { (videos) in
                self.videosVariable.onNext(videos)
                self.isLoadingVariable.onNext(false)
            }
        } catch {
            
        }
    }
    
    // MARK: - Private
    private let videosVariable = BehaviorSubject<[Video]>(value: [])
    private let isLoadingVariable = BehaviorSubject(value: false)
}
