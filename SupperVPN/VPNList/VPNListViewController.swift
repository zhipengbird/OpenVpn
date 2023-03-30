//
//  VPNListViewController.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/28.
//

import UIKit

class VPNListViewController: JXCollectListViewController {
    lazy var listViewModel: VPNListViewModel = {
        let model = VPNListViewModel()
        return model
    }()
    override func viewDidLoad() {
        self.viewModel = listViewModel
        super.viewDidLoad()
    }


}
