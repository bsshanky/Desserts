//
//  DessertDetailModel.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import Foundation

struct DessertDetail: Codable, Identifiable {
    var id: String
    var countryOfOrigin: String
    var instructions: String
    var youtubeURL: String?
    var ingredients: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case countryOfOrigin = "strArea"
        case instructions = "strInstructions"
        case youtubeURL = "strYoutube"
    }
    
    // Init for Preview only
    init(id: String,
         countryOfOrigin: String,
         instructions: String,
         youtubeURL: String,
         ingredients: [String]) {
        
        self.id = id
        self.countryOfOrigin = countryOfOrigin
        self.instructions = instructions
        self.youtubeURL = youtubeURL
        self.ingredients = ingredients
    }
    
    // Custom decoding to combine ingredients and measures dynamically
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.countryOfOrigin = try container.decode(String.self, forKey: .countryOfOrigin)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.youtubeURL = try? container.decode(String?.self, forKey: .youtubeURL)
        
        // Decode ingredients and measures dynamically
        var ingredients = [String]()
        
        let rawContainer = try decoder.container(keyedBy: RawCodingKeys.self)
        
        for i in 1...20 {
            
            guard let ingredientKey = RawCodingKeys(stringValue: "strIngredient\(i)"),
                  let measureKey = RawCodingKeys(stringValue: "strMeasure\(i)") else {
                continue // Skip if either key cannot be created
            }

            let ingredient = try rawContainer.decodeIfPresent(String.self, forKey: ingredientKey)
            let measure = try rawContainer.decodeIfPresent(String.self, forKey: measureKey)
            
            if let ingredient = ingredient, !ingredient.isEmpty, let measure = measure, !measure.isEmpty {
                ingredients.append("\(measure) \(ingredient)")
            }
        }
        
        self.ingredients = ingredients
    }
}

// Helper struct to handle dynamic keys
struct RawCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

