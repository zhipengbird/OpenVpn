//
//  VPNFileModel.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/29.
//

import UIKit

class VPNFileModel: NSObject, JXFeedContentModelProtocol, NSCoding, NSSecureCoding {
    var layout: String = ""
    var layoutInfo: [String : Any] = [:]
    var basePath: String?
    var fileName: String?
    var ipAddress: String?
    override init() {
        super.init()
    }
    func encode(with coder: NSCoder) {
        coder.encode(basePath, forKey: "basePath")
        coder.encode(fileName, forKey: "fileName")
        coder.encode(ipAddress, forKey: "ipAddress")
    }
    required init?(coder: NSCoder) {
        super.init()
        fileName = coder.decodeObject(forKey: "fileName") as? String
        ipAddress = coder.decodeObject(forKey: "ipAddress") as? String
        basePath = coder.decodeObject(forKey: "basePath") as? String
    }
    static var supportsSecureCoding: Bool {
        return true
    }
}

