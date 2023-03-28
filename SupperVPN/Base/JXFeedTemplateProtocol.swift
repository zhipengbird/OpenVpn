//
//  JXFeedTemplateProtocol.swift
//  GVideo
//
//  Created by 袁平华 on 2022/11/29.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import Foundation
/// 内容模板协议
protocol JXFeedContentCellTempateProtocol: NSObjectProtocol {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    var delegate: JXFeedCellEventProtocol? { get set }

    /// 通过模型配置cell
    /// - Parameter cellModel: cell 数据模型
    func config(cellModel: JXFeedContentModelProtocol)
    
    /// cell 将要展示
    func willDisplay()
    
    /// cell 结束展示
    func didEndDisplaying()
    /// cell 选中
    func didSelect()
    /// 通过数据模型计算模板的高度(用于tableview cell)
    /// - Parameter cellModel: cell数据模型
    /// - Returns: cell高度
    static func calculateForTable(cellModel: JXFeedContentModelProtocol) -> CGFloat
    
    /// 通过数据模型计算模板的高度(用于collectionview cell)
    /// - Parameter cellModel: cell数据模型
    /// - Returns: cell大小
    static func calculateForCollection(cellModel: JXFeedContentModelProtocol) -> CGSize
}

extension JXFeedContentCellTempateProtocol {
    /// cell 将要展示
    func willDisplay() {
        
    }
    /// cell 结束展示
    func didEndDisplaying() {
        
    }
    func didSelect() {
        
    }
}

/// 内容模型协议
protocol JXFeedContentModelProtocol {
    /// 布局类型
    var layout: String { get set }
    /// 用于存储不同元素的布局信息
    var layoutInfo: [String: Any] { get set }
    
}

/// 模板事件协议
protocol JXFeedCellEventProtocol: NSObjectProtocol {
    
}
