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


extension UIColor {
    static let orange = #colorLiteral(red: 0.9803921569, green: 0.5137254902, blue: 0.2509803922, alpha: 1)
    static let turquoise = #colorLiteral(red: 0, green: 0.7098039216, blue: 0.8117647059, alpha: 1)
    static let lighter_gray = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)

    static let analyzeBlue = #colorLiteral(red: 0.1333333333, green: 0.7098039216, blue: 0.8117647059, alpha: 1)
    static let yellowLight = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.8156862745, alpha: 1)
    static let pinkLight = #colorLiteral(red: 1, green: 0.9098039216, blue: 0.9411764706, alpha: 1)
    static let yellowStar = #colorLiteral(red: 0.968627451, green: 0.7568627451, blue: 0.1960784314, alpha: 1)
    static let pinkSelected = #colorLiteral(red: 0.8549019608, green: 0.1921568627, blue: 0.4274509804, alpha: 1)
    static let candidateBubbleView = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
    static let orangeTag = #colorLiteral(red: 0.9803921569, green: 0.5137254902, blue: 0.2509803922, alpha: 1)
    static let wanderlyYellow = #colorLiteral(red: 0.968627451, green: 0.7568627451, blue: 0.1960784314, alpha: 1)
    static let chatBubbleTurquoise = #colorLiteral(red: 0.137254902, green: 0.7058823529, blue: 0.8431372549, alpha: 1)
    static let charcoalGray = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
    static let lightOrange = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.7803921569, alpha: 1)
    static let highlightedOrange = #colorLiteral(red: 0.8980392157, green: 0.3607843137, blue: 0.03529411765, alpha: 1)
    static let selectAssignedToColor = #colorLiteral(red: 0.968627451, green: 0.9176470588, blue: 0.8941176471, alpha: 1)

    static let default_gray = #colorLiteral(red: 0.6274509804, green: 0.6235294118, blue: 0.6156862745, alpha: 1)
    static let popover_background_color = #colorLiteral(red: 0.6352941176, green: 0.6470588235, blue: 0.6745098039, alpha: 1)
    static let anonymousColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    static let specialtiesGrayText = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)

    static let contactOrMiscelaneusBackgroundColor = #colorLiteral(red: 0.7960784314, green: 0.9333333333, blue: 0.9568627451, alpha: 1)
    static let contactOrMiscelaneusTextColor = #colorLiteral(red: 0, green: 0.4666666667, blue: 0.5529411765, alpha: 1)
    static let jobProposalBackgroundColor = #colorLiteral(red: 0.9803921569, green: 0.8549019608, blue: 0.5137254902, alpha: 1)
    static let jobProposalTextColor = #colorLiteral(red: 0.6078431373, green: 0.4392156863, blue: 0, alpha: 1)
    static let applicationBackgroundColor = #colorLiteral(red: 0.8274509804, green: 0.9019607843, blue: 0.737254902, alpha: 1)
    static let applicationTextColor = #colorLiteral(red: 0.2666666667, green: 0.462745098, blue: 0, alpha: 1)

    static let tagPurpleTextColor = #colorLiteral(red: 0.2549019608, green: 0.09411764706, blue: 0.4666666667, alpha: 1)
    static let tagPurpleBackgroundColor = #colorLiteral(red: 0.8470588235, green: 0.7921568627, blue: 0.9176470588, alpha: 1)
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
