//
//  AppConfiguration.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

struct AppConfiguration {
    let environment: APIEnvironment
    let baseURL: URL

    static func current(
        bundle: Bundle = .main,
        processInfo: ProcessInfo = .processInfo
    ) -> AppConfiguration {
        let environment = resolveEnvironment(bundle: bundle, processInfo: processInfo)
        let baseURL = resolveBaseURL(
            environment: environment,
            bundle: bundle,
            processInfo: processInfo
        )

        return AppConfiguration(environment: environment, baseURL: baseURL)
    }

    private static func resolveEnvironment(
        bundle: Bundle,
        processInfo: ProcessInfo
    ) -> APIEnvironment {
        if let rawValue = processInfo.environment["SWIFTSOUND_API_ENVIRONMENT"],
           let environment = APIEnvironment(rawValue: rawValue) {
            return environment
        }

        if let rawValue = bundle.object(forInfoDictionaryKey: "SwiftSoundAPIEnvironment") as? String,
           let environment = APIEnvironment(rawValue: rawValue) {
            return environment
        }

        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    private static func resolveBaseURL(
        environment: APIEnvironment,
        bundle: Bundle,
        processInfo: ProcessInfo
    ) -> URL {
        if let rawValue = processInfo.environment["SWIFTSOUND_API_BASE_URL"],
           let url = URL(string: rawValue) {
            return url
        }

        if let rawValue = bundle.object(forInfoDictionaryKey: "SwiftSoundAPIBaseURL") as? String,
           let url = URL(string: rawValue) {
            return url
        }

        return environment.defaultBaseURL
    }
}
