//
//  UDManager.swift
//  OtoLink
//
//  Created by Devansh Vyas on 20/05/20.
//  Copyright © 2020 Rajan Shah. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

enum DefaultsKey: String, CaseIterable {
    case deviceId
    case vendorId
    case id
    case token
    case user
    case isLogin
    case settings
    case currentLatitude
    case zipcode
    case currentLongitude
    case customLatitude
    case customLongitude
    case currentPlace
    case appAnalyticsStart
    case appAnalyticsEnd
    case appScreenStart
    case appScreenEnd
    case loginSession
    case guestSession
}

class UDManager {
    static let shared = UDManager()
    let defaults = UserDefaults.standard
    var user: User?
    
    func setValue(for key: DefaultsKey, value: Any) {
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    func getString(for key: DefaultsKey) -> String? {
        return defaults.string(forKey: key.rawValue)
    }
    
    func getInt(for key: DefaultsKey) -> Int? {
        let int = defaults.integer(forKey: key.rawValue)
        return int > 0 ? int : nil
    }
    
    func getBool(for key: DefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    
    //MARK: - Getter Setter for Login User credentials
    func setUserData(json: JSON) {
        do {
            if let token = json[ApiConsts.Params.token].string {
                setValue(for: .token, value: token)
            }
            let userData = try json.rawData()
            self.user = try JSONDecoder().decode(User.self, from: userData)
            setValue(for: .isLogin, value: user?.status ?? false)
            //AppAnalytics.startUserSession()
            setValue(for: .user, value: userData)
        } catch {
            Logger.shared.log(error.localizedDescription)
        }
    }
    
    func getUserData() {
        if let userData = defaults.value(forKey: DefaultsKey.user.rawValue) as? Data {
            do {
                self.user = try JSONDecoder().decode(User.self, from: userData)
            } catch {
                Logger.shared.log("error-->" + error.localizedDescription)
            }
        }
    }
    
    func updateUserData() {
        do {
            let userData = try JSONEncoder().encode(user)
            defaults.set(userData, forKey: DefaultsKey.user.rawValue)
            defaults.synchronize()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Setter Getter for app session
    func setAppAnalytics(json: AppUsageDescription, type: AppAnalyticsUsageType) {
        do {
            let userData = try JSONEncoder().encode(json)
            switch type {
            case .appStart:
                setValue(for: .appAnalyticsStart, value: userData)
            case .appTerminate:
                setValue(for: .appAnalyticsEnd, value: userData)
            default: break
            }
        } catch {
            Logger.shared.logAnalytics(error.localizedDescription)
        }
        defaults.synchronize()
    }
    
    func getAppAnalyticsData(_ forKey: AppAnalyticsUsageType) -> AppUsageDescription? {
        var defaultKey :DefaultsKey = .appAnalyticsStart
        switch forKey {
        case .appStart:
            defaultKey = .appAnalyticsStart
        case .appTerminate:
            defaultKey = .appAnalyticsEnd
        case .loginSession:
            defaultKey = .loginSession
        default: break
        }
        if let userData = defaults.value(forKey: defaultKey.rawValue) as? Data {
            do {
                return try JSONDecoder().decode(AppUsageDescription.self, from: userData)
            } catch {
                Logger.shared.logAnalytics(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    //MARK: - Setter Getter for screen session
    func updateScreenAnalytics(data: Usagedescription, type: AppAnalyticsUsageType) {
        do {
            let userData = try JSONEncoder().encode(data)
            switch type {
            case .screenOpen:
                setValue(for: .appScreenStart, value: userData)
            case .screenClose:
                setValue(for: .appScreenEnd, value: userData)
            case .loginSession:
                setValue(for: .loginSession, value: userData)
            case .guestSession:
                setValue(for: .guestSession, value: userData)
            default: break
            }
        } catch {
            Logger.shared.logAnalytics(error.localizedDescription)
        }
    }
    
    func setScreenAnalytics(json: Usagedescription, type: AppAnalyticsUsageType) {
        do {
            let userData = try JSONEncoder().encode(json)
            switch type {
            case .screenOpen:
                setValue(for: .appScreenStart, value: userData)
            case .screenClose:
                setValue(for: .appScreenEnd, value: userData)
            case .loginSession:
                setValue(for: .loginSession, value: userData)
            case .guestSession:
                setValue(for: .guestSession, value: userData)
            default: break
            }
        } catch {
            Logger.shared.logAnalytics(error.localizedDescription)
        }
        defaults.synchronize()
    }
    
    func getScreenAnalyticsData(_ forKey: AppAnalyticsUsageType) -> Usagedescription? {
        var defaultKey = ""
        switch forKey {
        case .screenOpen(let screenName):
            defaultKey = screenName
        case .screenClose(let screenName):
            defaultKey = screenName
        case .loginSession:
            defaultKey = DefaultsKey.loginSession.rawValue
        case .guestSession:
            defaultKey = DefaultsKey.guestSession.rawValue
        default: break
        }
        if let userData = defaults.value(forKey: defaultKey) as? Data {
            do {
                return try JSONDecoder().decode(Usagedescription.self, from: userData)
            } catch {
                Logger.shared.logAnalytics(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    //MARK: - Remove from User Default
    func removeValue(for key: DefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func removeAllValues(_ exceptKeys: [DefaultsKey] = [.settings,
                                                        .deviceId,
                                                        .customLatitude,
                                                        .customLongitude,
                                                        .currentPlace,
                                                        .loginSession,
                                                        .guestSession,
                                                        .appAnalyticsStart,
                                                        .appAnalyticsEnd,
                                                        .appScreenStart]) {
        DefaultsKey.allCases.forEach { key in
            if !exceptKeys.contains(key) {
                defaults.removeObject(forKey: key.rawValue)
            }
        }
    }
    
    //MARK: - Add remove from locations detail User Default
    func getLastCustomLocation() -> CLLocationCoordinate2D? {
        guard let latitude = defaults.value(forKey: DefaultsKey.customLatitude.rawValue) as? Double else {
            return nil
        }
        guard let longitude = defaults.value(forKey: DefaultsKey.customLongitude.rawValue) as? Double else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func removeCustomLocation() {
        defaults.removeObject(forKey: DefaultsKey.customLatitude.rawValue)
        defaults.removeObject(forKey: DefaultsKey.customLongitude.rawValue)
    }
    
    func getLastCurrentLocation() -> CLLocationCoordinate2D? {
        guard let latitude = defaults.value(forKey: DefaultsKey.currentLatitude.rawValue) as? Double else {
            return nil
        }
        guard let longitude = defaults.value(forKey: DefaultsKey.currentLongitude.rawValue) as? Double else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func setCurrentLocation() {
        if let location = LocationService.sharedManager.currentLocation {
            self.removeCustomLocation()
            defaults.set(location.coordinate.latitude, forKey: DefaultsKey.currentLatitude.rawValue)
            defaults.set(location.coordinate.longitude, forKey: DefaultsKey.currentLongitude.rawValue)
        }
    }
    
}
