//
//  Food.swift
//  WasteNot
//
//  Created by David Allen on 4/20/24.
//

import Foundation
import UserNotifications

class Food: Codable, Equatable {
    static func == (lhs: Food, rhs: Food) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    var foodType: FoodType
    var name: String
    var startDate: Date?
    var packageDate: Date?
    
    private(set) var checkDate: Date?
    private(set) var expirationDate: Date?

    init(foodType: FoodType,
         name: String,
         checkDate: Date? = nil,
         expirationDate: Date? = nil,
         startDate: Date? = nil,
         packageDate: Date? = nil,
         expirationData: Expiration? = nil,
         emoji: String? = nil,
         id: String) {
        self.foodType = foodType
        self.name = name
        self.checkDate = checkDate
        self.expirationDate = expirationDate
        self.startDate = startDate
        self.packageDate = packageDate
        self.expirationData = expirationData
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.foodType = try container.decode(FoodType.self, forKey: .foodType)
        self.name = try container.decode(String.self, forKey: .name)
        self.expirationData = try container.decodeIfPresent(Expiration.self, forKey: .expirationData)
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        self.packageDate = try container.decodeIfPresent(Date.self, forKey: .packageDate)
        self.checkDate = try container.decodeIfPresent(Date.self, forKey: .checkDate)
        self.expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)
    }

    
    var expirationData: Expiration? = nil {
        didSet {
            if let expirationData = expirationData {
                if !expirationData.recommended {
                    expirationDate = Date()
                }
                else {
                    if let duration = expirationData.duration {
                        if let low = duration.first?.low {
                            let high = duration.first!.high!
                            
                            var lowDateComponents = DateComponents()
                            var highDateComponents = DateComponents()
                            
                            switch expirationData.unit {
                            case "hour":
                                lowDateComponents.hour = low
                                highDateComponents.hour = high
                            case "day":
                                lowDateComponents.day = low
                                highDateComponents.day = high
                            case "week":
                                lowDateComponents.day = low * 7
                                highDateComponents.day = high * 7
                            case "month":
                                lowDateComponents.month = low
                                highDateComponents.month = high
                            case "year":
                                lowDateComponents.year = low
                                highDateComponents.year = high
                            default:
                                checkDate = nil
                                expirationDate = nil
                                break
                            }
                            let calendar = Calendar(identifier: .gregorian)
                            checkDate = calendar.date(
                                byAdding: lowDateComponents,
                                to: startDate!
                            )
                            expirationDate = calendar.date(
                                byAdding: highDateComponents,
                                to: startDate!
                            )
                        }
                        else {
                            let length = duration.first!.length!
                            var dateComponents = DateComponents()
                            
                            switch expirationData.unit {
                            case "hour":
                                dateComponents.hour = length
                            case "day":
                                dateComponents.day = length
                            case "week":
                                dateComponents.day = length * 7
                            case "month":
                                dateComponents.month = length
                            case "year":
                                dateComponents.year = length
                            default:
                                expirationDate = nil
                                checkDate = nil
                                break
                            }
                            let calendar = Calendar(identifier: .gregorian)
                            expirationDate = calendar.date(
                                byAdding: dateComponents,
                                to: startDate!
                            )
                            
                            checkDate = expirationDate?.addingTimeInterval(-1*60*60*24)
                        }
                    }
                    else {
                        switch expirationData.unit {
                        case "use-by":
                            expirationDate = packageDate
                        case "indefinitely":
                            expirationDate = nil
                        default:
                            expirationDate = Date()
                        }
                        checkDate = expirationDate?.addingTimeInterval(-1*60*60*24)
                    }
                    
                }
            } else {
                checkDate = nil
                expirationDate = nil
            }
        }
    }
}

extension Food {
    
    static var foodsKey: String = "MyFoods"

    static func save(_ foods: [Food]) {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(foods)
        defaults.set(encodedData, forKey: foodsKey)
    }

    static func getFoods() -> [Food] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: foodsKey) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedFoods = try! decoder.decode([Food].self, from: data)
            return decodedFoods
        } else {
            return []
        }
    }

    func save() {
        var foods: [Food] = Food.getFoods()
        if let index = foods.firstIndex(where: { food in
            return food.id == self.id
        }) {
            foods.remove(at: index)
            foods.insert(self, at: index)
        } else {
            foods.append(self)
        }
        
        Food.save(foods)
    }
}
