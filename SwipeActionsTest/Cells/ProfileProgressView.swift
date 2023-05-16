//
//  ProfileProgressView.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import Foundation
import UIKit

final class ProfileProgressView: UIView {
    var arcWidth: CGFloat = 12
    var arcColor = UIColor.turquoise
    var arcBackgroundColor = UIColor.lighter_gray
    var profileImageView = UIImageView()
    var goldenImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        addSubview(profileImageView)
//        profileImageView.image = #imageLiteral(resourceName: "Recruiter Avatar")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.80).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.80).isActive = true

        addSubview(goldenImageView)
        goldenImageView.image = UIImage(named: "mycandidates")
        goldenImageView.translatesAutoresizingMaskIntoConstraints = false
        goldenImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        goldenImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
        goldenImageView.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: size).isActive = true
        goldenImageView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: size).isActive = true

        endArc = 0.25
        backgroundColor = .clear
        hideGoldenBadge()
    }

    func showGoldenBadge() {
        goldenImageView.isHidden = false
    }

    func hideGoldenBadge() {
        goldenImageView.isHidden = true
    }

    var endArc: CGFloat = 0.0 {   // in range of 0.0 to 1.0
        didSet{
            arcColor = UIColor.turquoise
            setNeedsDisplay()
        }
    }

    var size: CGFloat = 0.5

    func resizeAnonymousImageView(size: CGFloat) {
        self.size = size
        goldenImageView.removeFromSuperview()
        addSubview(goldenImageView)
        goldenImageView.image = UIImage(named: "mycandidates")
        goldenImageView.translatesAutoresizingMaskIntoConstraints = false
        goldenImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        goldenImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7).isActive = true
        goldenImageView.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: size).isActive = true
        goldenImageView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: size).isActive = true
    }

    func update(progress: Double) {
        endArc = CGFloat(progress)
    }

    func hideProgress() {
        arcColor = UIColor.clear
        arcBackgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        let fullCircle = 2.0 * CGFloat(Double.pi)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        var radius:CGFloat = 0.0
        if rect.width > rect.height{
            radius = (rect.width - arcWidth) - 5 / 2.0
        }else{
            radius = ((rect.height - arcWidth) - 5) / 2.0
        }

        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(arcWidth)
            context.setLineCap(.round)

            //make the circle background
            context.setStrokeColor(arcBackgroundColor.cgColor)
            context.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: false)
            context.strokePath()

            context.setStrokeColor(arcColor.cgColor)

            context.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
            context.strokePath()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
}
