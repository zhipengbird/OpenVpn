//
//  JXFeedModelLayerMapper.swift
//  GVideo
//
//  Created by 袁平华 on 2022/11/29.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit

class JXFeedModelLayerMapper: NSObject {
    let mapperType = "mapperType"
    let mapperClass = "mapperClass"
    private var layoutMapper: [String: [String: Any]] = [:]
    private var layoutList: [String] = []
    
    func contentClassForLayout(layout: String) -> JXFeedContentModelProtocol.Type? {
        guard let mapperInfo = self.layoutMapper[layout] else {
            return nil
        }
        let contentClass = mapperInfo[mapperClass]
        return contentClass as? JXFeedContentModelProtocol.Type
    }
    
    func register(layout: String, contentClass: JXFeedContentModelProtocol.Type) {
        var layoutInfo: [String: Any] = [:]
        layoutInfo[mapperType] = layout
        layoutInfo[mapperClass] = contentClass
        layoutMapper[layout] = layoutInfo
        layoutList.append(layout)
    }
}
