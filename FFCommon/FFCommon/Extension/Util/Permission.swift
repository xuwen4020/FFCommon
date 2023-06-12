//
//  Permission.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Photos
import AssetsLibrary
import MediaPlayer
import CoreTelephony
import CoreLocation
import CoreBluetooth
import Contacts

public enum AuthorizationStatus: String {
    case none = "未授权"
    case success = "已开启"
    case failed = "未开启"
}

public class Permission {
    
    public  enum AuthorizationType: String, CaseIterable
    {
        case camera = "相机"
        case library = "相册"
        case location = "位置"
        case network = "移动网络"
        case microphone = "麦克风"
        case media = "媒体库"
        case bluetooth = "蓝牙"
        case contacts = "联系人"
    }
    
    public static func status(_ type: AuthorizationType) -> AuthorizationStatus {
        switch type {
        case .camera:
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .notDetermined:
                return .none
            case .restricted, .denied:
                return .failed
            default:
                return .success
            }
        case .library:
            let authStatus = PHPhotoLibrary.authorizationStatus()
            switch authStatus {
            case .notDetermined:
                return .none
            case .restricted, .denied:
                return .failed
            default:
                return .success
            }
        case .location:
            let authStatus = CLLocationManager.authorizationStatus()
            switch authStatus {
            case .notDetermined:
                return .none
            case .restricted, .denied:
                return .failed
            default:
                return .success
            }
        case .network:
            let authStatus = CTCellularData().restrictedState
            switch authStatus {
            case .restrictedStateUnknown, .notRestricted:
                return .none
            default:
                return .success
            }
        case .microphone:
            let permissionStatus = AVAudioSession.sharedInstance().recordPermission
            switch permissionStatus {
            case .undetermined:
                return .none
            case .denied:
                return .failed
            default:
                return .success
            }
        case .media:
            let authStatus = MPMediaLibrary.authorizationStatus()
            switch authStatus {
            case .notDetermined:
                return .none
            case .restricted, .denied:
                return .failed
            default:
                return .success
            }
        case .bluetooth:
            let authStatus = CBCentralManager().state
            switch authStatus {
            case .unauthorized:
                return .none
            case .unsupported:
                return .failed
            default:
                return .success
            }
        case .contacts:
            let authStatus = CNContactStore.authorizationStatus(for: .contacts)
            switch authStatus {
            case .notDetermined:
                return .none
            case .restricted, .denied:
                return .failed
            default:
                return .success
            }
        }
    }
    
    public static func openSetting(_ type: AuthorizationType)
    {
        let title = "访问权限受限"
        let message = "请在iPhone的设置选项中，允许\"\(KAppName)\"使用您的\(type.rawValue)，点击“前往”，开启访问权限"
        DispatchQueue.main.async {
            let url = URL(string: UIApplication.openSettingsURLString)
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title:"取消", style: .cancel, handler:nil))
            alertController.addAction(UIAlertAction(title:"前往", style: .default, handler: {
                (action) -> Void in
                if UIApplication.shared.canOpenURL(url!)
                {
                    UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                }
            }))
            let vc = UIViewController.currentViewController()
            vc?.present(alertController)
        }
    }
}

extension Permission {
    
    /// 相机权限
    public static func checkCameraAuthority(callback: @escaping (Bool) -> Void)
    {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted
                {
                    DispatchQueue.main.async {
                        callback(granted)
                    }
                }
                else
                {
                    callback(false)
                    Permission.openSetting(.camera)
                }
            }
        case .restricted, .denied:
            callback(false)
            Permission.openSetting(.camera)
        default:
            callback(true)
        }
    }
    
    /// 相册权限
    public static func checkLibraryAuthority(callback: @escaping (Bool) -> Void)
    {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus
        {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted
                {
                    DispatchQueue.main.async {
                        callback(granted)
                    }
                }
                else
                {
                    Permission.openSetting(.library)
                }
            }
        case .restricted, .denied:
            callback(false)
            Permission.openSetting(.library)
        default:
            callback(true)
        }
    }
    
    /// 麦克风权限
    public static func checkMicrophoneAuthority(callback: @escaping (Bool) -> Void)
    {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        switch permissionStatus
        {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted
                {
                    DispatchQueue.main.async {
                        callback(granted)
                    }
                }
                else
                {
                    Permission.openSetting(.microphone)
                }
            }
        case .denied:
            callback(false)
            Permission.openSetting(.microphone)
        default: callback(true)
        }
    }
    /// 媒体权限
    public static func checkMediaAuthority(callback: @escaping (Bool) -> Void)
    {
        let authStatus = MPMediaLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if (status == MPMediaLibraryAuthorizationStatus.authorized) {
                    DispatchQueue.main.async {
                        callback(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        Permission.openSetting(.media)
                    }
                }
            }
        case .restricted, .denied:
            callback(false)
            Permission.openSetting(.media)
        default:
            callback(true)
        }

    }
    /// 位置权限
    public static func checkLocationAuthority(callback: @escaping (Bool) -> Void)
    {
        if !CLLocationManager.locationServicesEnabled() { callback(false) }

        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted
        {
            callback(false)
            Permission.openSetting(.location)
        }
        else
        {
            callback(true)
        }
    }
    /// 联系人权限
    public static func checkContactAuthority(callback: @escaping (Bool) -> Void)
    {
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if granted
                {
                    DispatchQueue.main.async {
                        callback(granted)
                    }
                }
                else
                {
                    callback(false)
                    Permission.openSetting(.contacts)
                }
            })
        case .restricted, .denied:
            callback(false)
            Permission.openSetting(.contacts)
        default:
            callback(true)
        }
    }
    
}


