import SwiftUI
import Foundation

/// Represents the response structure for a career opportunities API call.
struct CareerResponse: Codable {
    /// Array of `CareerOpportunity` objects representing individual career opportunities.
    let results: [CareerOpportunity]
}

/// A model representing a single career opportunity, including its title and associated company.
class CareerOpportunity: Identifiable, Codable, Hashable {
    // MARK: Properties
    
    /// Unique identifier for the career opportunity.
    let id: Int
    
    /// Title of the career opportunity.
    let title: String
    
    /// The company offering the career opportunity.
    let company: Company
    
    // MARK: Equatable Conformance
    
    /// Equatable protocol conformance to compare two `CareerOpportunity` instances.
    static func == (lhs: CareerOpportunity, rhs: CareerOpportunity) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: Hashable Conformance
    
    /// Hashable protocol conformance to generate a hash value for a `CareerOpportunity`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use the `id` for generating the hash value.
    }
}

/// A model representing a company that offers career opportunities.
struct Company: Codable {
    /// A nested `CompanyImage` struct containing URLs to company images.
    let image: CompanyImage
}

/// A model representing various sizes of a company's logo image.
struct CompanyImage: Codable {
    /// URL string pointing to the extra-small version of the company's logo.
    let xs: String // Assuming `xs` stands for "extra small".
}
