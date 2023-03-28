//
//  JXFeedListViewModel.swift
//  GVideo
//
//  Created by 袁平华 on 2023/3/2.
//  Copyright © 2023 JXNTV. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 列表数据请求的基础模板
class JXFeedListViewModel: JXBaseListViewModel {
    /// 总数
    var total: Int?
    func loadData(isRefresh: Bool = false) {
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
        apiManager.request(requestTarget()) {[weak self] result in
            switch result {
                case .failure(let error):
                    self?.dataSubject.onNext(.failure(error))
                    self?.isRequesting = false
                case .success(let response):
                    self?.isRequesting = false
//                    self?.handleResult(result: result, isRefresh: isRefresh)
            }
        }
        //        apiManager.request(requestTarget()) { [weak self] result in
        //            guard let result = result as? JSON else {
        //                self?.dataSubject.onNext(.success([]))
        //                return
        //            }
        //            self?.handleResult(result: result, isRefresh: isRefresh)
        //            self?.isRequesting = false
        //
        //        } failure: { [weak self] error in
        //            self?.dataSubject.onNext(.failure(error))
        //            self?.isRequesting = false
        //        }
    }
    
    func requestTarget() -> APIManager {
        //子类根据实际情况返回target
        fatalError("子类返回实际的Target")
    }
    
    func handleResult(result: JSON, isRefresh: Bool) {
        hasMore = result["hasMore"].boolValue
        total = result["total"].intValue
        let list = result["list"].arrayValue
        let resultList = parseList(list: list)
        if isRefresh {
            itemList = resultList
        } else {
            itemList.append(contentsOf: resultList)
        }
        affinityGrouping()
        self.dataSubject.onNext(.success(itemList))
    }
    
    func parseList(list: [JSON]) -> [JXFeedContentModelProtocol] {
        // 子类解析数据列表
        return []
    }
    
    func affinityGrouping() {
        // 子类进行数据分组
    }
}
