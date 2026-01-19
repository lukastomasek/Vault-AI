//
//  Tools.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-12-21.
//

import Foundation
import FoundationModels

struct CurrentDateTool: Tool {
    let name: String = "current_date"
    let description: String = "Returns the current date"

    @Generable
    struct Arguments {
        @Guide(description: "The date to format")
        var date: String
    }

    func call(arguments: Arguments) async throws -> String {
        let date = arguments.date
        let dt = DateFormatter()
        dt.dateStyle = .full

        let dateString = dt.string(from: Date())
        let result = "Today's date is \(dateString)"

        return result
    }
}
