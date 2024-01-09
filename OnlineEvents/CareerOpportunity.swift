//
//  CareerOpportunity.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 09/01/2024.
//

import SwiftUI
import Foundation

struct CareerResponse: Codable {
    let results: [CareerOpportunity]
}

class CareerOpportunity: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let company: Company

    static func == (lhs: CareerOpportunity, rhs: CareerOpportunity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Company: Codable {
    let image: CompanyImage
}

struct CompanyImage: Codable {
    let xs: String
}

