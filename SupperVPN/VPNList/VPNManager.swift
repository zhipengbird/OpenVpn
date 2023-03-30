//
//  VPNManager.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/29.
//

import Foundation
import MMDB_Swift
import FlagKit
import RxSwift
class VPNManager {
    //MARK: - properties
    let dataSubject = PublishSubject<VPNFileModel?>()

    static let shared = VPNManager()
    public lazy var mmdb: MMDB? = {
        if let mmdbPath = Bundle.main.path(forResource: "GeoLite2-Country", ofType: "mmdb") {
            return MMDB(mmdbPath)
        }
        assertionFailure("Please download GeoLite2-Country.mmdb and embed it in the root of VPNOnKit.")
        return nil
    }()
    
    var currentVPNFile: VPNFileModel? {
        didSet {
            self.dataSubject.onNext(currentVPNFile)
            if oldValue != nil {
                saveVPN()
            }
        }
    }
    init() {
        self.readVPN()
    }
    
    public typealias MMDBLookupCallback = (_ country: MMDBCountry?) -> Void
    
    //MARK: - API
    public func countryOfIP(_ IP: String) -> MMDBCountry? {
        if let mmdb = self.mmdb, let country = mmdb.lookup(IP) {
            return country
        }
        return nil
    }
    func saveVPN() {
        // 序列化
        do {
            guard let currentVPNFile = currentVPNFile else { return  }
            let data = try NSKeyedArchiver.archivedData(withRootObject: currentVPNFile, requiringSecureCoding: true)
            // 存储到本地文件
            let def = UserDefaults.standard
            def.set(data, forKey: "YFConfigData")
            def.synchronize()
        } catch let erro {
            print(erro)
        }
    }
    func readVPN() {
        // 反序列化
                let def = UserDefaults.standard
                if let data = def.object(forKey: "YFConfigData") as? Data {
                    do {
                        let configData =  try NSKeyedUnarchiver.unarchivedObject(ofClass: VPNFileModel.self, from: data)
                        self.currentVPNFile = configData
                    } catch let error  {
                        print(error)
                    }
                }
    }
}
