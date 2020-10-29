//
//  ViewController.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit

class ViewController: UIViewController {

    var backgroundManager: BackgroundManager {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {

            preconditionFailure("Missing App Delegate!")
        }

        return appDelegate.backgroundManager
    }

    @IBOutlet weak var tableView: UITableView?

    let ledgerURL = BackgroundTaskLedger.ledgerURL
    var ledger: BackgroundTaskLedger?

    lazy var dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    @IBAction func fetchButtonTapped(_ sender: UIButton) {

        backgroundManager.performBackgroundFetch(bgTask: nil)

        ledger = BackgroundTaskLedger(ledgerURL: ledgerURL)
        tableView?.reloadData()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ledger = BackgroundTaskLedger(ledgerURL: ledgerURL)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        ledger = BackgroundTaskLedger(ledgerURL: ledgerURL)
        tableView?.reloadData()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ledger?.entries.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LedgerEntry", for: indexPath)

        cell.textLabel?.text = dateFormatter.string(from: ledger?.entries[indexPath.row].dateTime ?? Date())

        return cell
    }
}
