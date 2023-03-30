//
//  JXBaseListViewModel.swift
//  GVideo
//
//  Created by 袁平华 on 2022/12/7.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit
import RxSwift

class JXBaseListViewModel: NSObject {
    let dataSubject = PublishSubject<Result<([JXFeedContentModelProtocol]), Error>>()
    //数据列表
    var itemList: [JXFeedContentModelProtocol] = []
    //分组数据列表
    var groupList: [[JXFeedContentModelProtocol]] = []
    //分组数据头部列表
    var groupHeaderList: [JXFeedContentModelProtocol] = []
    var pageIndex: Int = 1
    var pageSize = 20
    var hasMore: Bool = false
    var isRequesting = false
}
