//
//  CurrentVPNInfoView.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/29.
//

import UIKit
import FlagKit
class CurrentVPNInfoView: UIView {
    //MARK: - properties
    lazy var countryFlagView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    lazy var arrowFlagView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.right.circle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryFlagView, countryNameLabel, arrowFlagView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.setCustomSpacing(10, after: countryNameLabel)
        return stackView
    }()
    //MARK: - life circle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
        configSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - config UI
    func configSubViews() {
        addSubview(infoStackView)
        countryFlagView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 15))
        }
        arrowFlagView.snp.makeConstraints { make in
            make.size.equalTo(arrowFlagView.image?.size ?? CGSize(width: 30, height: 30))
        }
    }
    
    func configSubViewsLayout(){
        infoStackView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    //MARK: - api
    func configVPNContent() {
        if let current = VPNManager.shared.currentVPNFile, let ip = current.ipAddress {
            let country = VPNManager.shared.countryOfIP(ip)
            self.countryNameLabel.text = (country?.names["zh-CN"] ?? (country?.continent.names?["zh-CN"] ?? "")) + "(\(current.fileName ?? ""))"
            if let countryCode = country?.isoCode.uppercased() ?? country?.continent.code,
                let flag = Flag(countryCode: countryCode) {
                countryFlagView.image = flag.image(style: .roundedRect)
            } else {
                countryFlagView.image = UIImage()
            }
        }
    }
   
    
    
}
