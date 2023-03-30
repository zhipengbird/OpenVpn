//
//  VPNListViewModel.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/28.
//

import UIKit

class VPNListViewModel: JXFeedListViewModel {
    override func loadData(isRefresh: Bool = false) {
        //加载文件列表
        if isRequesting {
            return
        }
        if isRefresh {
            pageIndex = 1
        } else {
            if !hasMore {
                return
            }
            pageIndex += 1
        }
        isRequesting = true
        let path = Bundle.main.bundlePath
        let dir = path.appending("/VPNSource")
        do {
            let contentpath = try FileManager.default.contentsOfDirectory(atPath: dir)
            print(contentpath)
            self.itemList = contentpath.compactMap { file -> VPNFileModel in
                let model = VPNFileModel()
                model.basePath = "VPNSource"
                model.fileName = file
                model.layout = "vpn"
                return model
            }
            isRequesting = false
            hasMore = false
            self.dataSubject.onNext(.success(itemList))
        } catch let error  {
            print(error)
        }
    }
}
