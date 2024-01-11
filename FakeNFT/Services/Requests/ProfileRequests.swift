//
//  ProfileRequests.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 15.12.2023.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct PutProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod = HttpMethod.put
    var body: Data?

    init(profile: ProfileUpdate) {
        var dataString = "name=\(profile.name)&description=\(profile.description)&website=\(profile.website)"
        profile.likes.forEach { likeId in
            dataString += "&likes=\(likeId)"
        }
        self.body = dataString.data(using: .utf8)
    }
}
