//
//  JXFeedContentCellMapper.swift
//  GVideo
//
//  Created by 袁平华 on 2022/11/29.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit

class JXFeedContentCellMapper: NSObject {
    let mapperCellClass = "cellClass"
    let mapperCellInteractorClass = "cellInteractorClass"
    var modelLayerMapper: JXFeedModelLayerMapper = JXFeedModelLayerMapper()
    var layoutMapper: [String: [String: AnyClass]] = [:]
    /// 配置映射表数据，子类要根据自己的业务进行重写
    func setup() {
        //TODO:: 模板注册
    }
    
    override init() {
        super.init()
        setup()
    }
    /// 注册到对应的tableView
    /// - Parameter tableView: tableview 实例
    func registerCell(for tableView: UITableView) {
        for (_, mapper) in layoutMapper {
            let cellClass: AnyClass? =  mapper[mapperCellClass]
            tableView.register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass))
        }
    }
    /// 注册到对应的CollectionView
    /// - Parameter collectionView: collectionView 实例
    func registerCell(for collectionView: UICollectionView) {
        for (_, mapper) in layoutMapper {
            let cellClass: AnyClass? =  mapper[mapperCellClass]
            collectionView.register(cellClass.self, forCellWithReuseIdentifier: String(describing: cellClass))
        }
    }
    
    /// 获取模型对应的cell class
    /// - Parameter content: 模型类型
    /// - Returns: cell class
    func cellClass(for content: JXFeedContentModelProtocol) -> JXFeedContentCellTempateProtocol.Type? {
        let infoMapper = self.layoutMapper[content.layout]
        let cellClass: AnyClass? = infoMapper?[mapperCellClass]
        return cellClass as? JXFeedContentCellTempateProtocol.Type
    }
    
    /// 获取对应的代理类
    /// - Parameter content: 内容模型
    /// - Returns: cell 代理类
    func cellInteractorClass(for content: JXFeedContentModelProtocol) -> JXFeedCellEventProtocol.Type? {
        let infoMapper = self.layoutMapper[content.layout]
        let cellClass: AnyClass? = infoMapper?[mapperCellInteractorClass]
        return cellClass as? JXFeedCellEventProtocol.Type
    }
    
    /// 注册
    /// - Parameters:
    ///   - layout: 布局类型
    ///   - contentClass: 内容模型
    ///   - cellClass: cell 类
    ///   - cellInteractorClass: cell 事件代理类
    func register(layout: String, contentClass: JXFeedContentModelProtocol.Type, cellClass: JXFeedContentCellTempateProtocol.Type, cellInteractorClass: JXFeedCellEventProtocol.Type? = nil ) {
        self.modelLayerMapper.register(layout: layout, contentClass: contentClass)
        var infoMaper: [String: AnyClass] = [:]
        infoMaper[mapperCellClass] = cellClass
        infoMaper[mapperCellInteractorClass] = cellInteractorClass
        layoutMapper[layout] = infoMaper
    }
}
