//
//  ViewController.swift
//  SwipeActionsTest
//
//  Created by Daniel Meneses León on 16/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerCell(with: "CandidateTableViewCell")
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction = .init(style: .destructive, title: "Delete") { action, _, callback in
            // TODO: -
        }
        return .init(actions: [action])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction = .init(style: .normal, title: "Edit") { action, _, callback in
            // TODO: -
        }
        return .init(actions: [action])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CandidateTableViewCell.identifier,
                                                       for: indexPath) as? CandidateTableViewCell else { return .init() }
        cell.delegate = self
//        guard let candidateId = candidate.id else { fatalError("No candidate login?!?!") }
//        cell.configure(with: candidate, candidateImage: viewModel.fetchCandidateImage(from: candidateId))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
}

extension ViewController: CandidateTableViewCellDelegate {
    func candidateTableViewCell(sender: CandidateTableViewCell, didTapOnSpecialties specialties: [String]) {
        // TODO: -
    }

    func candidateTableViewCell(sender: CandidateTableViewCell, didNotTapOnSpecialties: Bool) {
        // TODO: -
    }
}

extension UITableView {
    func registerCell(with name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
}
