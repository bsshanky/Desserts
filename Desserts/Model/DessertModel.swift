//
//  DessertModel.swift
//  Desserts
//
//  Created by Shashank  on 6/18/24.
//

import Foundation

// Model to represent a dessert
struct Dessert: Identifiable, Codable, Hashable {
    var id: String
    var dessertName: String
    var dessertThumbUrl: String
    
    // Custom CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case dessertName = "strMeal"
        case dessertThumbUrl = "strMealThumb"
    }
}

struct DessertListResponse: Codable {
    var desserts: [Dessert]
    
    enum CodingKeys: String, CodingKey {
        case desserts = "meals" // Mapping the "meals" key in JSON to the "desserts" property
    }
}
