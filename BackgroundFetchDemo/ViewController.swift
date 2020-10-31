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

        ledger = BackgroundTaskLedger()
        tableView?.reloadData()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerForNotifications()
        ledger = BackgroundTaskLedger()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        ledger = BackgroundTaskLedger()
        tableView?.reloadData()
    }

    func registerForNotifications() {

        NotificationCenter.default.addObserver(forName: .newPokemonFetched, object: nil, queue: nil) { (notification) in

            print("notification received")
            if let uInfo = notification.userInfo, let _ = uInfo["pokemon"] as? Pokemon {
                self.ledger = BackgroundTaskLedger()
                self.tableView?.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ledger?.entries.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = BackgroundFetchTableviewCell.dequeueReusableCell(from: tableView, for: indexPath)

        if let entry = ledger?.entries[indexPath.row] {

            cell.pokemonSpeciesName?.text = entry.message
            cell.pokemonFetchDate?.text = dateFormatter.string(from: entry.dateTime)
        } else {
            cell.pokemonSpeciesName?.text = "Missing Entry"
            cell.pokemonFetchDate?.text = nil
        }

        return cell
    }
}
