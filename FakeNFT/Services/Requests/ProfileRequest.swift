//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 29.12.2023.
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

    init(profile: ProfileModel) {
       let description = String(describing: profile.description)
       let website = String(describing: profile.website)

        var dataString = "name=\(profile.name)&description=\(description)&website=\(website)"

        profile.likes.forEach { likeId in
            dataString += "&likes=\(likeId)"
        }
        self.body = dataString.data(using: .utf8)
    }
 }
