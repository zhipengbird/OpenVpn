//
//  vpnConentCellMapper.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/29.
//

import UIKit

class vpnConentCellMapper: JXFeedContentCellMapper {
    override func setup() {
        self.register(layout: "vpn", contentClass: VPNFileModel.self, cellClass: VpnItemCollectionViewCell.self)
    }
}
