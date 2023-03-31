//
//  VpnItemCollectionViewCell.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/29.
//

import UIKit
import TunnelKitOpenVPN
import FlagKit
import SwifterSwift
class VpnItemCollectionViewCell: UICollectionViewCell, JXFeedContentCellTempateProtocol {
    //MARK: - properties
    var delegate: JXFeedCellEventProtocol?
    var cellModel: VPNFileModel!
    lazy var fileNameLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var ipAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    lazy var listStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [flagImageView, infoStack])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    lazy var infoStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fileNameLable, ipAddressLabel, countryLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    //MARK: - life circle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
        configSubviewsLayout()
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.contentView.layer.shadowRadius = 10
        self.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.contentView.layer.shadowOpacity = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - configUI
    func configSubviews() {
        contentView.addSubview(listStack)
    }
    func configSubviewsLayout() {
        listStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        flagImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    //MARK: - protocol imp
    func config(cellModel: JXFeedContentModelProtocol) {
        guard let cellModel = cellModel as? VPNFileModel else { return  }
        self.cellModel = cellModel
        configContent()
    }
    func configContent() {
        fileNameLable.text = cellModel.fileName
        guard let base = cellModel.basePath, let file = cellModel.fileName else { return }
        let path = Bundle.main.bundlePath + "/\(base)/\(file)"
        let url  = URL(fileURLWithPath: path)
        do {
            let result = try OpenVPN.ConfigurationParser.parsed(fromURL: url)
            if  let point = result.configuration.remotes?.first {
                let ip = point.address
                cellModel.ipAddress = ip
                self.ipAddressLabel.text = ip
                let country = VPNManager.shared.countryOfIP(ip)
                self.countryLabel.text = country?.names["zh-CN"] ?? country?.continent.names?["zh-CN"]
                if let countryCode = country?.isoCode.uppercased() ?? country?.continent.code, let flag = Flag(countryCode: countryCode) {
                    flagImageView.image = flag.image(style: .roundedRect)
                } else {
                    flagImageView.image = UIImage(systemName: "paperplane.circle.fill")
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    static func calculateForTable(cellModel: JXFeedContentModelProtocol) -> CGFloat {
        return 0
    }
    
    static func calculateForCollection(cellModel: JXFeedContentModelProtocol) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 100, height: 100)
    }
    func didSelect() {
        VPNManager.shared.currentVPNFile = cellModel
        self.parentViewController?.dismiss(animated: true)
    }
}
