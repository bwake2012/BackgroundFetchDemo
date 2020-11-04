//
//  ViewController.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!

    var backgroundManager: BackgroundManager {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {

            preconditionFailure("Missing App Delegate!")
        }

        return appDelegate.backgroundManager
    }

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var refreshControl: UIRefreshControl?

    let ledgerURL = BackgroundFetchLedger.ledgerURL
    var ledger: BackgroundFetchLedger { return BackgroundFetchLedger.shared }

    @IBAction func fetchButtonTapped(_ sender: UIButton) {

        backgroundManager.performBackgroundFetch(bgTask: nil)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView?.addSubview(refreshControl)
        self.refreshControl = refreshControl

        versionLabel.text = Bundle.appVersion

        registerForNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        tableView?.reloadData()
    }

    func registerForNotifications() {

        NotificationCenter.default.addObserver(forName: .newPokemonFetched, object: nil, queue: nil) { (notification) in

            print("notification received")
            if let uInfo = notification.userInfo, let _ = uInfo["pokemon"] as? Pokemon {
                 self.tableView?.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = ledger.entries.count
        print("Ledger entries: \(count)")
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = BackgroundFetchTableviewCell.dequeueReusableCell(from: tableView, for: indexPath)

        cell.configure(with: ledger.entries[indexPath.row])

        return cell
    }

    @objc func refresh(sender: UIRefreshControl) {

        tableView?.reloadData()
        
        refreshControl?.endRefreshing()
    }
}
