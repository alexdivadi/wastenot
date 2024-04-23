//
//  FoodTypes.swift
//  WasteNot
//
//  Created by David Allen on 4/20/24.
//

import Foundation

let categories: [String: String] = [
    "Dairy Products & Eggs": "🥚",
    "Food Purchased Frozen":"🍦",
    "Shelf Stable Foods":"🍯",
    "Produce - Fresh Vegetables":"🥬",
    "Produce - Fresh Fruits":"🍓",
    "Baked Goods - Bakery":"🥐",
    "Baked Goods - Baking and Cooking":"🥖",
    "Baked Goods - Refrigerated Dough":"🍞",
    "Deli & Prepared Foods":"🥗",
    "Grains, Beans & Pasta":"🌾",
    "Condiments, Sauces & Canned Goods":"🥫",
    "Baby Food":"🍼",
    "Beverages":"🧃",
    "Meat - Fresh":"🥩",
    "Meat - Smoked or Processed":"🥓",
    "Meat - Stuffed or Assembled":"🍖",
    "Meat - Shelf Stable Foods":"🥫",
    "Poultry - Fresh":"🐓",
    "Poultry - Cooked or Processed":"🍗",
    "Poultry - Stuffed or Assembled":"🍗",
    "Poultry - Shelf Stable Foods":"🥫",
    "Seafood - Fresh":"🐟",
    "Seafood - Smoked":"🍣",
    "Seafood - Shellfish":"🍤",
    "Vegetarian Proteins":"🧆",
]

let foodTypes: [FoodType]! = loadJson(filename: "expiration_data")?.sorted { lhs, rhs in
    return lhs.name < rhs.name
} ?? []


func loadJson(filename fileName: String) -> [FoodType]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let jsonData = try decoder.decode(FoodTypeFeed.self, from: data)
            return jsonData.foods
        } catch {
            print("error:\(error)")
        }
    }
    else {
        print("Couldn't load file:", fileName)
    }
    return nil
}

struct Duration: Codable {
    var low: Int?
    var high: Int?
    var length: Int?
}
struct Tip: Codable {
    var fridge: String?
    var freezer: String?
    var pantry: String?
}

struct Expiration: Codable {
    var storage: String
    var recommended: Bool
    var unit: String?
    var duration: [Duration]?
    var fromDate: String?
}

struct FoodTypeFeed: Decodable {
    var foods: [FoodType]
}

struct FoodType: Codable, Equatable {
    static func == (lhs: FoodType, rhs: FoodType) -> Bool {
        lhs.name == rhs.name
    }
    
    let name: String
    let category: String
    let expiration: [Expiration]
    
    let tips: Tip?
    
    private(set) var emoji: String?
    
    init(name: String,
         category: String,
         expiration: [Expiration],
         tips: Tip? = nil) {
        self.name = name
        self.category = category
        self.expiration = expiration
        self.tips = tips
        self.emoji = categories[self.category]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(String.self, forKey: .category)
        self.expiration = try container.decode([Expiration].self, forKey: .expiration)
        self.tips = try container.decodeIfPresent(Tip.self, forKey: .tips)
        self.emoji = categories[self.category]
    }
}
