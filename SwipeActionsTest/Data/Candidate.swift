//
//  Candidate.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import Foundation
import UIKit

struct CandidateData: Codable {
    let candidates: [Candidate]?
    let total: Int?
    let page: Int?
}

struct SingleCandidate: Codable {
    let candidate: Candidate?
}

struct CandidateJob: Codable {
    let id: Int?
    let job_type_label: String?
    let job_type: String?
    let location: String?
    let facility: FacilityData?
    let facility_string: String?
    let profession: String?
    let status: String?
    let specialties: [String]?

    func hasOpenJob() -> Bool {
        guard let status = status, status.lowercased().contains("posted") else {
            return false
        }
        return true
    }

}

struct FacilityData: Codable {
    let name: String?
}

struct CandidateChatListPage: Codable {
    let current_page: Int?
    let data: [CandidateChat]?
    let total: Int?
    let last_page: Int?
}

extension CandidateChatListPage: Paginable {

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

protocol InboxPresentable { }

final class Candidate: Codable, InboxPresentable {
    let id: Int?
    let email: String?
    let phone: String?
    let first_name: String?
    let last_name: String?
    var channel_id: String?
    var name: String?
    let profession: String?
    let photo: String?
    let inbox_last_message: String?
    let specialties: [String]?
    let inbox_tags: [String]?
    let completion_percentage: Double?
    var is_favorite: Bool?
    let last_login: String?
    let last_message_time: String?
    var is_anonymous: Bool?
    let license_locations: [String]?
    let years_exp: Int?
    let documents_completed: [String]?
    let preferred_location: [String]?
    let preferred_shift: [String]?
    let preferred_assignment_length: String?
    var chats: [CandidateChat]?
    var documents: [Document]?
//    var jobPage: JobListPage?
    var documentPage: DocumentListPage?
    var chatPage: CandidateChatListPage?
    var notePage: NoteListPage?
    var notes: [Note]?
    var inbox_unread: Bool?
    var is_archived: Bool
    let interactions: [String]?
    var recruiter_assigned: Recruiter?

    init(id: Int? = nil,
         email: String? = nil,
         phone: String? = nil,
         first_name: String? = nil,
         last_name: String? = nil,
         name: String? = nil,
         channel_id: String? = nil,
         profession: String? = nil,
         photo: String? = nil,
         inbox_last_message: String? = nil,
         specialties: [String]? = nil,
         inbox_tags: [String]? = nil,
         completion_percentage: Double? = nil,
         is_favorite: Bool? = nil,
         is_archived: Bool = false,
         last_login: String? = nil,
         last_message_time: String? = nil,
         is_anonymous: Bool? = nil,
         license_locations: [String]? = nil,
         years_exp: Int? = nil,
         documents_completed: [String]? = nil,
         preferred_location: [String]? = nil,
         preferred_shift: [String]? = nil,
         preferred_assignment_length: String? = nil,
         chats: [CandidateChat]? = nil,
         documents: [Document]? = nil,
//         jobPage: JobListPage? = nil,
         documentPage: DocumentListPage? = nil,
         chatPage: CandidateChatListPage? = nil,
         notePage: NoteListPage? = nil,
         notes: [Note]? = nil,
         inbox_unread: Bool? = nil,
         interactions: [String]? = nil,
         recruiter_assigned: Recruiter? = nil
    ) {
        self.id = id
        self.email = email
        self.phone = phone
        self.first_name = first_name
        self.last_name = last_name
        self.name = name
        self.channel_id = channel_id
        self.profession = profession
        self.photo = photo
        self.inbox_last_message = inbox_last_message
        self.specialties = specialties
        self.inbox_tags = inbox_tags
        self.completion_percentage = completion_percentage
        self.is_favorite = is_favorite
        self.last_login = last_login
        self.last_message_time = last_message_time
        self.is_anonymous = is_anonymous
        self.license_locations = license_locations
        self.years_exp = years_exp
        self.documents_completed = documents_completed
        self.preferred_location = preferred_location
        self.preferred_shift = preferred_shift
        self.preferred_assignment_length = preferred_assignment_length
        self.chats = chats
//        self.jobPage = jobPage
        self.documents = documents
        self.documentPage = documentPage
        self.chatPage = chatPage
        self.notePage = notePage
        self.notes = notes
        self.is_archived = is_archived
        self.inbox_unread = inbox_unread
        self.interactions = interactions
        self.recruiter_assigned = recruiter_assigned
    }

    var formattedName: String {
        guard let isAnonymous = is_anonymous, !isAnonymous else {
            return ""
        }
        return ((first_name ?? "") + " " + (last_name ?? "")).capitalized
    }

    var hasUnread: Bool {
        inbox_unread ?? false
    }

    func markInboxRead() {
        inbox_unread = false
    }

    func makeInboxTags() -> [String] {
        var inboxTags: [String] = []
        if let inbox_tags = inbox_tags {
            for tag in inbox_tags {
//                if tag.isProfile() {
//                    inboxTags.append(Constant.Keys.miscellaneousUpper)
//                } else if tag.isContactInfo() {
//                    inboxTags.append(Constant.Keys.contact)
//                } else {
                    inboxTags.append(tag.replacingOccurrences(of: "_", with: " "))
//                }
            }
        }
        return inboxTags
    }

    func formattedSpecialties(color: UIColor = .turquoise, isShortened: Bool = true) -> NSMutableAttributedString {
        var aNames = specialties?.map { "\($0)"} ?? []
        let names = aNames
        if names.count > 3 && isShortened {
            aNames = Array(aNames.prefix(upTo: 3))
        }
        let resultAttributedString = NSMutableAttributedString()
        for specialtyName in aNames {
            let firstAttributedString = NSMutableAttributedString(string: specialtyName.uppercased())
            firstAttributedString.addAttribute(NSAttributedString.Key.backgroundColor,
                                               value: color, range: NSMakeRange(0, specialtyName.count))
            let secondAttributedString = NSMutableAttributedString(string: "  ")
            secondAttributedString.addAttribute(NSAttributedString.Key.backgroundColor,
                                                value: UIColor.clear, range: NSMakeRange(0, "  ".count))
            resultAttributedString.append(firstAttributedString)
            resultAttributedString.append(secondAttributedString)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byTruncatingTail

        resultAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value:paragraphStyle, range:NSMakeRange(0, resultAttributedString.length))
        resultAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                            value:UIColor.white, range:NSMakeRange(0, resultAttributedString.length))
        resultAttributedString.addAttribute(NSAttributedString.Key.font,
                                            value:UIFont.concourse(size: 12), range:NSMakeRange(0, resultAttributedString.length))

        return resultAttributedString
    }

    func formattedGraySpecialties(isShortened: Bool = true, fontSize: CGFloat = 12) -> NSMutableAttributedString {
        var aNames = specialties?.map { "●\($0)"} ?? []
        let names = aNames
        if names.count > 3 && isShortened {
            aNames = Array(aNames.prefix(upTo: 3))
        }
        let resultAttributedString = NSMutableAttributedString()
        for specialtyName in aNames {
            let firstAttributedString = NSMutableAttributedString(string: specialtyName)
            let secondAttributedString = NSMutableAttributedString(string: "  ")
            secondAttributedString.addAttribute(NSAttributedString.Key.backgroundColor,
                                                value: UIColor.clear, range: NSMakeRange(0, "  ".count))
            resultAttributedString.append(firstAttributedString)
            resultAttributedString.append(secondAttributedString)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byTruncatingTail

        resultAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                            value:paragraphStyle, range:NSMakeRange(0, resultAttributedString.length))
        resultAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                            value:UIColor.specialtiesGrayText,
                                            range:NSMakeRange(0, resultAttributedString.length))
        resultAttributedString.addAttribute(NSAttributedString.Key.font,
                                            value:UIFont.latoRegular(size: fontSize), range:NSMakeRange(0, resultAttributedString.length))

        return resultAttributedString
    }

    func makeMessageDate() -> String {
        let dateF = DateFormatter.isoDateFormatter
        if let date = dateF.date(from:last_message_time ?? "") {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let hour = formatter.string(from: date) // Oct 8, 2020 at 11:10 PM
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Today, \(hour)"
            } else if calendar.isDateInTomorrow(date) {
                return "Tomorrow, \(hour)"
            } else if calendar.isDateInYesterday(date) {
                return "Yesterday, \(hour)"
            }
            let aFormatter = DateFormatter()
            aFormatter.dateFormat = "MMMM d, YYYY"
            //aFormatter.timeStyle = .short
            let dateString = aFormatter.string(from: date)// + " " + hour // Oct 8, 2020 at 11:10 PM
            return dateString
        }
        return ""
    }

    func shouldShowMessagesTab() -> Bool {
        guard let chats = chats else {
            return false
        }
        return !chats.isEmpty
    }

    func shouldShowDocumentsTab() -> Bool {
        guard let documents = documents else {
            return false
        }
        return !documents.isEmpty && is_anonymous == false
    }

    func shouldShowProfileTab() -> Bool {
        guard let interactions = interactions, !interactions.isEmpty else {
            return false
        }
        return interactions.contains("profile")
    }

    func shouldHideEmailAndPhone() -> Bool {
        guard let is_anonymous = is_anonymous else {
            return true
        }
        return is_anonymous
    }

    func shouldHidePreferredLocations() -> Bool {
        guard let preferredLocations = preferred_location else {
            return true
        }
        return preferredLocations.isEmpty ? true : false
    }

    func shouldHidePreferredShifts() -> Bool {
        guard let preferredShift = preferred_shift else {
            return true
        }
        return preferredShift.isEmpty ? true : false
    }

    func shouldHidePreferredAssignmentLength() -> Bool {
        guard let assignment = preferred_assignment_length else {
            return true
        }
        return assignment.isEmpty ? true : false
    }

    func shouldHideYearsOfExperience() -> Bool {
        guard let yearsExp = years_exp else {
            return true
        }
        return yearsExp <= 0 ? true : false
    }

    func shouldHidePhone() -> Bool {
        guard let phone = phone else {
            return true
        }
        return phone.isEmpty || shouldHideEmailAndPhone() ? true : false
    }

    func shouldHideLicenseLocations() -> Bool {
        guard let locations = license_locations else {
            return true
        }
        return locations.isEmpty ? true : false
    }

    func isIncomplete() -> Bool {
        guard let isAnonymous = is_anonymous else {
            return false
        }

        if isAnonymous {
            return years_exp == 0 && (documents_completed == nil || documents_completed?.isEmpty == true)
        }

        return false
    }

    func hasInboxTags() -> Bool {
        guard let tags = inbox_tags, !tags.isEmpty else {
            return false
        }
        return true
    }

    struct Request: Codable {
        struct Search: Codable {
            let text: String
        }

        struct Favorite: Codable {
            let favorite: Bool
        }

        struct Reassign: Codable {
            let owner_id: Int
        }
    }
//    struct Response: Codable {
//
//        struct Generic: Codable {
//            let message: String?
//            let success: Bool?
//        }
//
//        struct CandidateProfile: Codable {
//            let message: String?
//            let success: Bool?
//            let data: SingleCandidate?
//        }
//
//        struct NotificationCounter: Codable {
//            let message: String?
//            let success: Bool?
//            let data: InboxNotificationCounter?
//        }
//
//        struct CandidateChats: Codable {
//            let message: String?
//            let success: Bool?
//            let data: CandidateChatListPage?
//        }
//
//        struct List: Codable {
//            let message: String?
//            let success: Bool?
//            let data: CandidateData?
//        }
//
//        struct AnonymousSearch: Codable {
//            let message: String?
//            let success: Bool?
//            let data: CandidateSearchResponse?
//        }
//
//    }
}



public final class CandidateChat: Codable, InboxMenu {
    let id: Int?
    let channel_id: String?
    var unread: Bool?
    let job: CandidateJob?
    var seen: Int?
//    let details: ChatDetailsDataDetailsDetails?
    let created_at: String?
    let updated_at: String?
    let nurse: ChatDetailsNurse?

    public func hasOpenJob() -> Bool {
        guard let job = job else {
            return false
        }
        guard let status = job.status, status.lowercased().contains("posted") else {
            return false
        }
        return true
    }
}

public struct ChatDetailsNurse: Codable {
    let has_applied: Bool
    let has_quick_applied: Bool

}

protocol InboxMenu { }

class InboxDocuments: InboxMenu { }

class InboxProfileEmptyState: InboxMenu { }
class InboxProfileGeneralInfo: InboxMenu { }
class InboxProfileNotes: InboxMenu { }
class InboxProfileHistory: InboxMenu { }
class InboxProfileTags: InboxMenu { }
class InboxProfileTearsheet: InboxMenu { }

extension DateFormatter {
    
    static let isoDateFormatter: DateFormatter = {
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        let iso8601DateFormatter = DateFormatter()
        iso8601DateFormatter.locale = enUSPOSIXLocale
        iso8601DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        iso8601DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return iso8601DateFormatter
    }()
}
