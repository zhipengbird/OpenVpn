//
//  ViewController.swift
//  SupperVPN
//
//  Created by 袁平华 on 2023/3/28.
//

import UIKit
import TunnelKitCore
import TunnelKitManager
import TunnelKitOpenVPN
import SnapKit
private let appGroup = "group.com.VPN.yph"

private let tunnelIdentifier = "com.yuanph.SupperVPN.SupperVPNTunnel"
class ViewController: UIViewController {
    //MARK: - properties
    private let vpn = NetworkExtensionVPN()
    private var vpnStatus: VPNStatus = .disconnected
    private let keychain = Keychain(group: appGroup)
    var  userName = "5MsFBzefp4bD8DC8yTCZvbZT"
    var password = "ws9Jp2kGP2HcTj3Qz3p8cH7j"
    private var cfg: OpenVPN.ProviderConfiguration?
    //MARK: - ui properties
    lazy var connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(connectionClicked), for: .touchUpInside)
        return button
    }()
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择", for: .normal)
        button.addTarget(self, action: #selector(selectClicked), for: .touchUpInside)
        return button
    }()
    lazy var currentVPNView: CurrentVPNInfoView = {
        let view = CurrentVPNInfoView()
        return view
    }()
    lazy var listStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentVPNView,connectButton, listButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    //MARK: - life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNStatusDidChange(notification:)),
            name: VPNNotification.didChangeStatus,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNDidFail(notification:)),
            name: VPNNotification.didFail,
            object: nil
        )
        
        Task {
            await vpn.prepare()
        }
        view.addSubview(listStack)
        listStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        VPNManager.shared.dataSubject.subscribe { model in
            self.updateCurrentVPNInfo()
        }
        self.updateCurrentVPNInfo()
        // Do any additional setup after loading the view.
    }
    func updateCurrentVPNInfo() {
        self.currentVPNView.configVPNContent()
    }
    //MARK: - event
    @objc func connectionClicked() {
        switch vpnStatus {
            case .disconnected:
                connect()
                
            case .connected, .connecting, .disconnecting:
                disconnect()
        }
    }
    @objc func selectClicked() {
        let vc = VPNListViewController()
        self.present(vc, animated: true)
    }
    //MARK: - connect/disconnect
    func connect() {
        let credentials = OpenVPN.Credentials(userName, password)
        
        if let currenVpn = VPNManager.shared.currentVPNFile, let base = currenVpn.basePath, let file = currenVpn.fileName {
            let path = Bundle.main.bundlePath + "/\(base)/\(file)"
            let url  = URL(fileURLWithPath: path)
            let result = try? OpenVPN.ConfigurationParser.parsed(fromURL: url)
            if let config = result?.configuration {
                cfg = OpenVPN.ProviderConfiguration("VPN", appGroup: appGroup, configuration: config)
                cfg?.shouldDebug = true
                cfg?.debugLogPath = "VPN"
                
            }
        }
        let passwordReference: Data
        do {
            passwordReference = try keychain.set(password: credentials.password, for: credentials.username, context: tunnelIdentifier)
            cfg?.username = credentials.username
        } catch {
            print("Keychain failure: \(error)")
            return
        }
        if let config = cfg {
            Task {
                var extra = NetworkExtensionExtra()
                extra.passwordReference = passwordReference
                try await vpn.reconnect(
                    tunnelIdentifier,
                    configuration: config,
                    extra: extra,
                    after: .seconds(2)
                )
            }
            
        }
    }
    func disconnect() {
        Task {
            await vpn.disconnect()
        }
    }
    func updateButton() {
        switch vpnStatus {
            case .connected:
                connectButton.setTitle("Disconnect", for: .normal)

            case .connecting:
                connectButton.setTitle("Connecting", for: .normal)
                
            case .disconnected:
                connectButton.setTitle("Connect", for: .normal)
                
            case .disconnecting:
                connectButton.setTitle("Disconnecting", for: .normal)
        }
    }
    //MARK: - nofication handler
    @objc private func VPNStatusDidChange(notification: Notification) {
        vpnStatus = notification.vpnStatus
        print("VPNStatusDidChange: \(vpnStatus)")
        updateButton()
    }
    
    @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
    }
    
}

