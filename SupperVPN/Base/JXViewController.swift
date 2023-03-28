//
//  JXViewController.swift
//  GVideo
//
//  Created by 袁平华 on 2022/12/8.
//  Copyright © 2022 JXNTV. All rights reserved.
//

import UIKit
enum PageViewState: Int {
    case unknown
    case empty
    case unLogin
    case badNetwork
    case loading
    case data
    case loadingMore
}

public class JXViewController: UIViewController {
    var pageState: PageViewState = .unknown

    var loadingView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }
    //MARK: - life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK: - view status
    func updateViewState(state: PageViewState) {
        self.dismissLoadingView()
        hiddenAllAbnormalView()
        switch state {
            case .empty:
                showEmptyView()
                handleDataSuccess()
            case .unLogin:
                showUnloginView()
            case .badNetwork:
                showBadNetView()
            case .loading:
                if pageState != .data {
                    showLoadingView()
                }
            case .data:
                handleDataSuccess()
            case .unknown:
                break
            case .loadingMore:
                break
        }
        pageState = state

    }
    /// 展示空视图（在没有数据时展示）
    func showEmptyView() {
//        self.view.showEmpty(
//            imageName: GVITheme.image(.normal, themeImage: .THEME_I_NO_DATA),
//            bgColor: GVITheme.color(.normal, .THEME_C_W_D1),
//            marginTop: 0
//            )
    }
    
    /// 展示未登录视图（在要求登录时展示）
    func showUnloginView() {
//        self.showNoLogin(title: "登录后查看", btnText: "登录", marginTop: 0) {
//            navigator.present(GVIPage.login.url)
//        }
    }
    /// 展示网络错误视图
    func showBadNetView() {
//        self.view.showBadNetwork(
//            imageName: GVITheme.image(.normal, themeImage: .THEME_I_NO_NET),
//            marginTop: 0,
//            bgColor: GVITheme.color(.normal, .THEME_C_W_D1)
//            ) { [weak self] in
//            self?.refresh()
//        }
    }
    /// 展示数据加展示图
    func  showLoadingView() {
//        self.loadingView?.removeFromSuperview()
//        self.loadingView = GVILoadingView(bgColor: GVITheme.color(.normal, .THEME_C_W_D1))
//        view.addSubview(self.loadingView!)
//        loadingView?.snp.makeConstraints({ make in
//            make.edges.equalToSuperview()
//        })
    }
    /// 关闭数据加展示图
    func dismissLoadingView() {
        self.loadingView?.removeFromSuperview()
    }
    /// 隐藏提示示图
    func hiddenAllAbnormalView() {
//        self.view.hideAbnormal()
//        self.hideAbnormal()
    }
    /// 数据加载成功后，要做的事情，（如结束刷新）
    func handleDataSuccess() {
        
    }
    /// 刷新事件
    func refresh() {
        
    }
}
