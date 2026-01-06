//
//  Models.swift
//  ReceiptCore
//
//  Created by Radhika Bajaj on 2026-01-04.
//

import Foundation

public struct Receipt: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var createdAt: Date
    public var merchantName: String
    public var purchaseDate: Date?
    public var totalAmount: Decimal?
    public var currencyCode: String
    public var assetFilenames: [String]   // saved images/PDF names
    public var notes: String?

    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        merchantName: String = "Unknown Merchant",
        purchaseDate: Date? = nil,
        totalAmount: Decimal? = nil,
        currencyCode: String = "USD",
        assetFilenames: [String] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.merchantName = merchantName
        self.purchaseDate = purchaseDate
        self.totalAmount = totalAmount
        self.currencyCode = currencyCode
        self.assetFilenames = assetFilenames
        self.notes = notes
    }
}
