//
//  ViewController.swift
//  TraktDemo
//
//  Created by Kirill Pahnev on 01/08/2018.
//

import SafariServices
import TraktKit
import UIKit

struct Client: ClientProvider {
    let clientId: String
    let secret: String?
}

struct Auth: Authenticator {
    let accessToken: String
}

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let accessTokenKey = "accessToken"

    let client = Client(clientId: Config.clientId,
                        secret: Config.secret)

    lazy var trakt = try! Trakt(traktClient: client)
    var safariSession: SFAuthenticationSession?

    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard Config.clientId != placeHolderValue && Config.secret != placeHolderValue else {
            fatalError("You should change the API key and secret to yours to make this example work.")
        }

        if let accessToken = UserDefaults.standard.value(forKey: accessTokenKey) as? String {
            trakt.authenticate(Auth(accessToken: accessToken))
        }

        trakt.getPopularMovies(pageNumber: 1) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                self.movies = value.type
            }
        }
    }

    @IBAction func login(_ sender: UIButton) {
        let completion: SFAuthenticationSession.CompletionHandler = { [weak self] callbackURL, error in
            guard let strongSelf = self,
                  let callbackURL = callbackURL else { return }
            strongSelf.trakt.getToken(from: callbackURL, redirectURI: Config.redirectURI, completion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print(value)
                    UserDefaults.standard.set(value.accessToken, forKey: strongSelf.accessTokenKey)
                    strongSelf.trakt.authenticate(Auth(accessToken: value.accessToken))
                }
            })
        }

        let authURL = trakt.oAuthURL(redirectURI: Config.redirectURI)
        safariSession = SFAuthenticationSession(url: authURL, callbackURLScheme: nil, completionHandler: completion)
        safariSession?.start()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = movies[indexPath.row]
        let vc = MovieDetailsViewController(trakt: trakt, movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }
}
