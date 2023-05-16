//
//  ApplicantTypeIndicatorCell.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import UIKit

final class ApplicantTypeIndicatorCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var maxWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var ballonTitleLabel: UILabel!
    var maxWidth: CGFloat? {
         didSet {
             guard let _ = maxWidth else {
                 return
             }
             // maxWidthConstraint.isActive = true
             // maxWidthConstraint.constant = maxWidth
         }
    }

    func configure(with title: String) {
        ballonTitleLabel.text = title.capitalized
        makeBackgroundColor(using: title)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
    }

    func makeBackgroundColor(using text: String) {
        let result = text.lowercased()
        if result.contains("virtual recruiter") {
            ballonTitleLabel.textColor = UIColor.white
            contentView.backgroundColor = UIColor.orange
        } else if result.contains("application") {
            ballonTitleLabel.textColor = UIColor.applicationTextColor
            contentView.backgroundColor = UIColor.applicationBackgroundColor
        } else if result.contains("proposal") {
            ballonTitleLabel.textColor = UIColor.jobProposalTextColor
            contentView.backgroundColor = UIColor.jobProposalBackgroundColor
        } else {
            ballonTitleLabel.textColor = UIColor.contactOrMiscelaneusTextColor
            contentView.backgroundColor = UIColor.contactOrMiscelaneusBackgroundColor
        }
    }

}
