//
//  Document.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import Foundation

final class Document: Codable, InboxMenu {
    let id: Int?
    var document_type: [String]?
    let created_at: String?
    let job: JobDocument?
    var unread: Bool?
    let recruiter: Recruiter?
//    let apps: [SubmissionApplication]?

    init(id: Int? = nil,
         document_type: [String]? = nil,
         created_at: String? = nil,
         job: JobDocument? = nil,
         unread: Bool? = nil,
         recruiter: Recruiter? = nil
//         apps: [SubmissionApplication]? = nil
    ) {
        self.id = id
        self.document_type = document_type
        self.created_at = created_at
        self.job = job
        self.unread = unread
        self.recruiter = recruiter
//        self.apps = apps
    }

    var isMiscellaneousDocument: Bool {
        guard let docType = document_type, !docType.isEmpty else  {
            return false
        }
        return docType.contains { value in
            value.lowercased() == "profile"
        }
    }

    struct Request: Codable {
        struct FetchDocumentList: Codable {
            let page: Int
        }

        struct FetchNotesWithFilters: Codable {
            let page: Int
            let recruiter_ids: String
        }

    }

    struct Response: Codable {

        struct DocumentList: Codable {
            let success: Bool?
            let message: String?
            let data: DocumentListPage?
        }

        struct DocumentDetailResponse: Codable {
            let success: Bool?
            let message: String?
            let data: DocumentDetailPage?
        }

    }
}

struct DocumentDetailPage: Codable {
    let id: Int?
    let documents: DocumentsDetailInfo?
    let recruiter: Recruiter?
    let received_at: String?
//    let job: JobDetail?
}

struct DocumentsDetailInfo: Codable {
    let summary: String?
    let summaryURl: String?
    let hasSharedProfile: Bool?
    let hasSummary: Bool?
    let hasAboutMe: Bool?
    let aboutmeURl: String?
    let aboutmeDownloadURl: String?
    let summary_safe_download_url: String?
    let aboutme_safe_download_url: String?
    let professional_safe_download_url: String?
    let professionalURl: String?
    let hasProfessional: Bool?
    let hasDocument: Bool?
    let hasChecklist: Bool?
    let resumes: [Resume]?
    let licenses: [License]?
    let medicals: [Medical]?
    let others: [Other]?
    let identifications: [Identification]?
    let certifications: [Certification]?
    let checklistsLists: [Checklist]?
}

struct Checklist: Codable {
    let documentURl: String?
    let name: String?
    let safe_download_url: String?
}

struct Medical: Codable {
    let name: String?
    let documentURl: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?
    let exp_date: String?
}

struct Other: Codable {
    let name: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?
    let documentURl: String?

}

struct Identification: Codable {
    let name: String?
    let thestate: LicenseState?
    let pdfurl: String?
    let pdfURl: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?

}

struct Certification: Codable {
    let name: String?
    let exp_date: String?
    let pdfurl: String?
    let documentURl: String?
    let downloadPdfURl: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?
}

struct Resume: Codable {
    let type: String?
    let name: String?
    let downloadURl: String?
    let pdfURl: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?
}

struct License: Codable {
    let name: String?
    let thestate: LicenseState?
    let number: String?
    let exp_date: String?
    let investigated: Bool?
    let pdfurl: String?
    let pdfURl: String?
    let downloadPdfURl: String?
    let safe_download_url: String?
    let safe_front_download_url: String?
    let safe_back_download_url: String?
    let preview_url: String?
    let issued_by: String?
}

struct LicenseState: Codable {
    let state: String?
}

struct DocumentListPage: Codable {
    let current_page: Int?
    let data: [Document]?
    var total: Int?
    let per_page: Int?
    let last_page: Int?
}

extension DocumentListPage: Paginable {

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

struct JobDocument: Codable {
    let id: Int?
    let status: String?
    let recruiter: Recruiter?
    let job_type_label: String?
    let job_type: String?
    let location: String?
    let facility: String?
    let profession: String?
    let specialties: [String]?

    func hasOpenJob() -> Bool {
        guard let status = status, status.lowercased().contains("posted") else {
            return false
        }
        return true
    }
}

extension Document {

    var type: DocumentType {
        if let documentType = document_type?.last {
            if documentType.lowercased().contains("quick") {
                return .quickApplication
            } else if documentType.lowercased().contains("profile") {
                return .miscellaneous
            } else if documentType.lowercased().contains("application") {
                return .application
            }
        }
        return .other
    }

    var title: String {
        if let documentType = document_type?.last {
            if documentType.lowercased().contains("quick") {
                return "Quick Application"
            } else if documentType.lowercased().contains("profile") {
                return Constant.Keys.miscellaneousRegular
            } else if documentType.lowercased().contains("application") {
                return "Application"
            }
        }
        return ""
    }
}

enum DocumentType {
    case application
    case quickApplication
    case miscellaneous
    case contactInfo
    case other
}


struct Constant {
    struct Keys {

        // For retreiving the wap access token for profile
        static let wapAccessToken = "wapAccessToken"

        // For retrieving the session
        static let chatIdentity = "ChatIdentity"
        static let chatToken = "ChatToken"
        static let authorizationToken = "AuthorizationToken"
        static let pushNotificationToken = "Push Notification Token"
        static let userID = "User ID"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let matrixLocation = "Matrix Location"
        static let miscellaneousUpper = "MISCELLANEOUS"
        static let contact = "CONTACT"
        static let miscellaneousRegular = "Miscellaneous Documents"
        static let username = "username"
        static let password = "password"
        static let onRememberMe = "onRememberMe"
        static let miscellaneous = "Miscellaneous"
    }
}
