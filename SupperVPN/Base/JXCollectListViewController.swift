//
//  JXCollectListViewController.swift
//  GVideo
//
//  Created by 袁平华 on 2022/12/7.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh
import ZLCollectionViewFlowLayout
class JXCollectListViewController: JXViewController {
    //MARK: - public properties
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    var contentCellMapper: JXFeedContentCellMapper = JXFeedContentCellMapper()
    var viewModel: JXFeedListViewModel = JXFeedListViewModel()
    var cellEventHandler: JXFeedCellEventProtocol?
    lazy var layout: UICollectionViewLayout = {
        return flowlayout()
    }()
    lazy var collectionListView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.contentInsetAdjustmentBehavior = .never
        view.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        view.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        return view
    }()
    let bag = DisposeBag()
    //MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentCellMapper.registerCell(for: collectionListView)
        configSubviews()
        configSubviewsLayout()
        addListener()
        refresh()
    }
    func flowlayout() -> UICollectionViewLayout {
        let layout = ZLCollectionViewVerticalLayout()
        layout.minimumLineSpacing = 10
        layout.delegate = self
        return layout
    }
    func addListener() {
        viewModel.dataSubject.subscribe(onNext: { [weak self] result in
            self?.collectionListView.reloadData()
            switch result {
                case .success(_):
                    self?.handleSuccess()
                case .failure(let error):
                    self?.handleFailed(error: error)
            }
        }).disposed(by: bag)
        //        viewModel.userStateClosure = {[weak self] _ in
        //            //用户登录状态改变
        //            self?.refresh()
        //        }
    }
    @objc func headerRefresh() {
        refresh()
    }
    override func refresh() {
        updateViewState(state: .loading)
        viewModel.loadData(isRefresh: true)
    }
    
    @objc func loadMore() {
        viewModel.loadData(isRefresh: false)
    }
    
    func handleSuccess() {
        collectionListView.mj_header?.endRefreshing()
        if viewModel.hasMore {
            collectionListView.mj_footer?.endRefreshing()
        } else {
            collectionListView.mj_footer?.endRefreshingWithNoMoreData()
        }
        if viewModel.itemList.isEmpty && viewModel.groupList.isEmpty {
            updateViewState(state: .empty)
        } else {
            updateViewState(state: .data)
        }
    }
    
    override func hiddenAllAbnormalView() {
        super.hiddenAllAbnormalView()
        //        self.collectionListView.hideAbnormal()
    }
    
    func handleFailed(error: Error?) {
        collectionListView.mj_header?.endRefreshing()
        collectionListView.mj_footer?.endRefreshing()
        //        if error?.code == .userUnLogin || error?.serverCode == .tokenInvalid {
        //            updateViewState(state: .unLogin)
        //        } else if viewModel.itemList.isEmpty {
        //            updateViewState(state: .badNetwork)
        //        }
    }
    // MARK: - subview config
    func configSubviews() {
        view.addSubview(collectionListView)
        
    }
    func configSubviewsLayout() {
        collectionListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension JXCollectListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(self.collectionListView)
    }
}

extension JXCollectListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? JXFeedContentCellTempateProtocol {
            cell.didSelect()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.willDisplay()
        }
        //分组情况下
        if self.viewModel.groupList.count > 0 {
            //是最后一组，且剩余数据个数小10时加载下一页
            if self.viewModel.groupList.count == indexPath.section + 1, self.viewModel.groupList[indexPath.section].count - indexPath.row < 10 {
                self.viewModel.loadData()
            }
        } else {
            // 未分组情况下
            if self.viewModel.itemList.count - indexPath.row < 10 {
                self.viewModel.loadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.didEndDisplaying()
        }
    }
}

extension JXCollectListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !self.viewModel.groupList.isEmpty {
            return viewModel.groupList[section].count
        }
        return viewModel.itemList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !self.viewModel.groupList.isEmpty {
            return viewModel.groupList.count
        }
        return viewModel.itemList.isEmpty ? 0 : 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item: JXFeedContentModelProtocol
        if !self.viewModel.groupList.isEmpty {
            item = viewModel.groupList[indexPath.section][indexPath.row]
        } else {
            item = viewModel.itemList[indexPath.row]
        }
        let itemClass = contentCellMapper.cellClass(for: item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemClass), for: indexPath)
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.config(cellModel: item)
            cell.delegate = cellEventHandler
        }
        return cell
    }
}

extension JXCollectListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var item: JXFeedContentModelProtocol
        if !self.viewModel.groupList.isEmpty {
            item = viewModel.groupList[indexPath.section][indexPath.row]
        } else {
            item = viewModel.itemList[indexPath.row]
        }
        let itemClass = contentCellMapper.cellClass(for: item)
        return itemClass?.calculateForCollection(cellModel: item) ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension JXCollectListViewController: ZLCollectionViewBaseFlowLayoutDelegate {
    
}
