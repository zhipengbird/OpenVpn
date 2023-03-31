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
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
