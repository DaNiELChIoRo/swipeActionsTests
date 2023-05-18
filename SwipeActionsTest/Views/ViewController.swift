//
//  ViewController.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import UIKit

/// Container View Controller?
class ViewController: UIViewController {

    var containerView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainer()
    }

    private func setupContainer() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let layoutGuide = view.safeAreaLayoutGuide
        containerView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true

        let alertGreenBubble = UIView()
        alertGreenBubble.backgroundColor = .unarchiveGreen
        containerView.addSubview(alertGreenBubble)
        alertGreenBubble.translatesAutoresizingMaskIntoConstraints = false

        let storyboard = UIStoryboard(name: "CandidateListViewController", bundle: nil)
        let vc: CandidateListViewController = storyboard.instantiateViewController(withIdentifier: "CandidateListViewController") as! CandidateListViewController
        addChild(vc)
//        vc.delegate = self
        containerView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: alertGreenBubble.bottomAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    }


}



extension UITableView {
    func registerCell(with name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
}
