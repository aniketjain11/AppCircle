//
//  ServerConfiguration.swift
//  BaseProject
//
//  Created by Aniket Jain on 31/07/23.
//

import Foundation

enum ServerConfiguration {
    enum ServerEnvironment: String {
        case staging = "Staging"
        case development = "Development"
        case production = "Production"
        
        private static let hostProtocol = "https:"
        
        fileprivate var domainName: String {
            switch self {
            case .staging: return "staging-domainName"
            case .development: return "development-domainName"
            case .production: return "production-domainName"
            }
        }
        
        fileprivate var imageHost: String {
            switch self {
            case .production: return "production-imageHost"
            case .staging, .development: return "staging,development-imageHost"
            }
        }
        
        fileprivate var middleLayerHost: String {
            switch self {
            case .production: return "production-middleLayerHost"
            case .staging: return "staging-middleLayerHost"
            case .development: return "development-middleLayerHost"
            }
        }
        
        private var host: String {
            ServerEnvironment.hostProtocol + "//" + domainName
        }
    }
    
    
    static var secret: String {
        guard let secret = Bundle.main.infoDictionary?["API_SECRET"] as? String else {
            fatalError("Server url not found")
        }
        return secret
    }
    
    static var currentEnvironment: ServerEnvironment {
        guard let serverEnvironmentRaw = Bundle.main.infoDictionary?["SERVER_ENVIRONMENT"] as? String else {
            fatalError("Server url not found")
        }
        let serverEnvironment = ServerEnvironment(rawValue: serverEnvironmentRaw)
        return serverEnvironment ?? ServerConfiguration.defaultEnvironment()
    }
    
    private static func defaultEnvironment() -> ServerEnvironment {
        let plistSavedAppEnvUserDefaultsKey = "server_preference_settings"
        guard
            let preference = UserDefaults.standard.value(forKey: plistSavedAppEnvUserDefaultsKey) as? String,
            let serverEnvironment =  ServerEnvironment(rawValue: preference)
        else {
            return .production
        }
        return serverEnvironment
    }
    
    static var domainName: String {
        currentEnvironment.domainName
    }
    
    static var imageHost: String {
        currentEnvironment.imageHost
    }
    
    static var middleLayerHost: String {
        currentEnvironment.middleLayerHost
    }
    
}
