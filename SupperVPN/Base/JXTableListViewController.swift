//
//  JXTableListViewController.swift
//  GVideo
//
//  Created by 袁平华 on 2022/12/7.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh
class JXTableListViewController: JXViewController {
    //MARK: - public properties
    var contentCellMapper: JXFeedContentCellMapper = JXFeedContentCellMapper()
    var viewModel: JXFeedListViewModel = JXFeedListViewModel()
    
    lazy var tabListView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .white
        view.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        view.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        return view
    }()
    let bag = DisposeBag()
    //MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentCellMapper.registerCell(for: tabListView)
        configSubviews()
        addListener()
        viewModel.loadData()
        // Do any additional setup after loading the view.
    }
    //MARK: - config Subviews
    func configSubviews() {
        view.addSubview(tabListView)
        tabListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addListener() {
        viewModel.dataSubject.subscribe (onNext: {
            [weak self] result in
            self?.tabListView.reloadData()
            switch result {
            case .success:
                self?.handleSuccess()
            case .failure(let error):
                self?.handleFailed(error: error)
            }
        }).disposed(by: bag)
        
    }
    //MARK: - refresh
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
    //MARK: - view status update
    func handleSuccess() {
        if viewModel.itemList.isEmpty {
            updateViewState(state: .empty)
        } else {
            updateViewState(state: .data)
        }
        tabListView.mj_header?.endRefreshing()
        if viewModel.hasMore {
            tabListView.mj_footer?.endRefreshing()
        } else {
            tabListView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    override func hiddenAllAbnormalView() {
        super.hiddenAllAbnormalView()
//        self.tabListView.hideAbnormal()
    }
    
    func handleFailed(error: Error?) {
        tabListView.mj_header?.endRefreshing()
        tabListView.mj_footer?.endRefreshing()
//        if error?.code == .userUnLogin || error?.serverCode == .tokenInvalid{
//            updateViewState(state: .unLogin)
//        } else if viewModel.itemList.isEmpty {
//            updateViewState(state: .badNetwork)
//        }
    }
}

extension JXTableListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.willDisplay()
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.didEndDisplaying()
        }
    }
}

extension JXTableListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.itemList[indexPath.row]
        let cellClass = contentCellMapper.cellClass(for: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
        if let cell = cell as? JXFeedContentCellTempateProtocol {
            cell.config(cellModel: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.itemList[indexPath.row]
        let cellClass = contentCellMapper.cellClass(for: model)
        return cellClass?.calculateForTable(cellModel: model) ?? 0
    }
}
