//
//  Model.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

struct Venue: Decodable {
    let name: String
    let description: String
    let deliveryFee: Int
    let deliveryTime: Int
    let thumbnailURL: URL

    enum VenueDataKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case deliveryFee = "delivery_fee"
        case deliveryTime = "asap_time"
        case thumbnailURL = "cover_img_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VenueDataKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        deliveryFee = try container.decode(Int.self, forKey: .deliveryFee)
        deliveryTime = try container.decode(Int.self, forKey: .deliveryTime)
        thumbnailURL = try container.decode(URL.self, forKey: .thumbnailURL)
    }

}
