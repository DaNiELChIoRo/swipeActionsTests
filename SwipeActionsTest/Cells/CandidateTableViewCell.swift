//
//  CandidateCEll.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import UIKit

protocol CandidateTableViewCellDelegate: AnyObject {
    func candidateTableViewCell(sender: CandidateTableViewCell,
                                didTapOnSpecialties specialties: [String])
    func candidateTableViewCell(sender: CandidateTableViewCell,
                                didNotTapOnSpecialties: Bool)
}

final class CandidateTableViewCell: UITableViewCell {
    static let identifier = "CandidateTableViewCell"

    weak var delegate: CandidateTableViewCellDelegate?
    var candidate: Candidate?

    @IBOutlet weak var seeMoreSpecialtiesButton: UIButton! {
        didSet {
            seeMoreSpecialtiesButton.setTitle("", for: .normal)
        }
    }

    @IBOutlet private weak var professionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var actionCollectionView: UICollectionView! {
        didSet {
            actionCollectionView.backgroundColor = UIColor.clear
            actionCollectionView.delegate = self
            actionCollectionView.dataSource = self
            actionCollectionView.registerCell(with: "ApplicantTypeIndicatorCollectionViewCell")
        }
    }
    @IBOutlet private weak var starIcon: UIImageView!
    @IBOutlet private weak var redDotView: UIView!
    @IBOutlet private weak var specialtiesLabel: UILabel!
    @IBOutlet private weak var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var progressView: ProfileProgressView!

    @IBOutlet weak var recruiterAvatar: UIImageView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private var documents: [String] = []
//    lazy var session: Sessionable = {
//        DependencyAssembler.dependencies.session()
//    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        recruiterAvatar.makeCircled()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        deselectCell()
        recruiterAvatar.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        redDotView.layer.cornerRadius = redDotView.frame.height / 2
     }

//    func configure(with candidate: Candidate,
//                   candidateImage: UIImage?) {
//        self.candidate = candidate
//
//        professionLabel.text = candidate.profession ?? ""
//        commentLabel.text = candidate.inbox_last_message
//        progressView.profileImageView.image = candidateImage
//
//        if candidate.recruiter_assigned?.id == session.user?.id {
//            recruiterAvatar.image = makeProfileImage()
//        } else {
//            recruiterAvatar.setImage(for: candidate.recruiter_assigned?.image)
//        }
//
//        progressView.update(progress: Double(candidate.completion_percentage ?? 0)/100)
//        documents = candidate.makeInboxTags()
//        if !documents.isEmpty {
//            collectionViewHeightConstraint.constant = 40
//            actionCollectionView.reloadData()
//        } else {
//            collectionViewHeightConstraint.constant = 0
//        }
//
//        dateLabel.text = candidate.makeMessageDate()
//
//        if let isFavorite = candidate.is_favorite, isFavorite {
//            starIcon.isHidden = false
//        } else {
//            starIcon.isHidden = true
//        }
//
//        let hasSpecialties = !(candidate.specialties?.isEmpty ?? true)
//        if hasSpecialties {
//            specialtiesLabel.attributedText = candidate.formattedGraySpecialties(fontSize: 12)
//        } else {
//            specialtiesLabel.isHidden = true
//        }
//        authorLabel.text = candidate.formattedName
//        progressView.hideProgress()
//        progressView.hideGoldenBadge()
//        redDotView.isHidden = (candidate.inbox_unread ?? false ? false : true)
//    }

    @IBAction func showSpecialtiesOptionTapped(_ sender: UIButton) {
        if specialtiesLabel.isTruncated() {
            displaySpecialties()
        } else {
            delegate?.candidateTableViewCell(sender: self, didNotTapOnSpecialties: true)
        }
    }

    func markAsRead() {
        redDotView.isHidden = true
    }

    @objc func displaySpecialties() {
        if let specialties = candidate?.specialties {
            delegate?.candidateTableViewCell(sender: self, didTapOnSpecialties: specialties)
        }
    }

    func selectCell() {
        containerView.backgroundColor = UIColor.lighter_gray
    }

    func deselectCell() {
        containerView.backgroundColor = UIColor.white
    }
}

// MARK: UICollectionView DataSource, CollectionDelegate, DelegateFlowLayout
extension CandidateTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ApplicantTypeIndicatorCollectionViewCell = collectionView.dequeue(cellForItemAt: indexPath)
        let text = documents[indexPath.row]
        cell.configure(with: text)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = documents[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width - 37, height: 22)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension UILabel {

    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        let myText = self.text! as NSString
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : self.font]

        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width,
                                                         height: CGFloat.greatestFiniteMagnitude),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: attributes,
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }

    func isTruncated() -> Bool {
        guard numberOfLines > 0 else { return false }
        return countLabelLines() > numberOfLines
    }


    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: font as Any],
                                           context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}


extension UIView {
    func circular() {
        self.layer.cornerRadius = self.frame.height / 2
    }

    /// calculates the cornerRadius based on the width of the component
    func makeCircled() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

    func makeRounded() {
        layer.cornerRadius = self.frame.height * 0.2
        clipsToBounds = true
    }
}

extension UICollectionView {

    func registerCell(with name: String) {
        let nib = UINib(nibName: name, bundle:  nil)
        register(nib, forCellWithReuseIdentifier: name)
    }

    func dequeue<T: UICollectionViewCell>(cellForItemAt indexPath: IndexPath) -> T {
      return self.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }

}
