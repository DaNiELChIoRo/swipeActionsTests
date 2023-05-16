//
//  Notes.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import Foundation

struct SubmitNotes {
    struct Request: Encodable {
        let content: String
    }

    struct Response: Decodable {
        let message: String?
        let success: Bool?
    }
}

class Recruiter: Codable {
    var id: Int?
    var full_name: String?
    var image: String?
    var first_name: String?
    var last_name: String?

    var firstname: String?
    var lastname: String?

    struct Response: Codable {

        struct List: Codable {
            let success: Bool?
            let message: String?
            let data: [Recruiter]?
        }
    }
}

class Note: Codable {
    var id: Int?
    var content: String?
    var created_at: String?
    var recruiter: Recruiter?
}

struct NoteListPage: Codable {
    let current_page: Int?
    let last_page: Int?
    let total: Int?
    let data: [Note]?
}

extension NoteListPage: Paginable {

    var currentPage: Int {
        return (current_page ?? 0)
    }

    var numberOfElements: Int {
        return total ?? 0
    }

    func hasNextPage() -> Bool {
        if let lastPage = last_page {
            return lastPage > currentPage
        }
        return false
    }

}

struct NotesList {
    struct Response: Decodable {
        let message: String?
        let success: Bool?
        let data: NoteListPage?
    }
}

protocol Paginable {
    var numberOfElements: Int { get }
    var currentPage: Int { get }

    func hasNextPage() -> Bool
}

final class Paginator<Elem: Paginable> {
    var currentPage = 0
    var totalElements = 0
    var currentElement: Elem?
    var isFetching = false

    init(element: Elem?) {
        if let elem = element {
            currentPage = elem.currentPage
            totalElements = elem.numberOfElements
            currentElement = elem
        }
    }

    func updatePage(elem: Elem) {
        currentElement = elem
        currentPage = elem.currentPage
    }

    func hasNextPage() -> Bool {
        if let elem = currentElement {
            return elem.hasNextPage()
        }
        return false
    }

}
