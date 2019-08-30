//
//  MovieDetailsViewController.swift
//  TMDBDemo
//
//  Created by Kirill Pahnev on 19/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import UIKit
import TraktKit

class MovieDetailsViewController: UIViewController {

    let movie: Movie
    private let trakt: Trakt
    private var fullMovie: Movie? {
        didSet {
            guard let fullMovie = fullMovie else { return }
            ratingLabel.text = String(describing: fullMovie.votes)
        }
    }
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!

    init(trakt: Trakt, movie: Movie) {
        self.trakt = trakt
        self.movie = movie

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        trakt.getMovieDetails(for: movie.ids.trakt) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                self.fullMovie = value
            }
        }

        trakt.getHistory(type: .shows, pageNumber: 1) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                print(value)
                self.watchedLabel.text = value.type.contains(where: { $0.movie?.ids.trakt == self.movie.ids.trakt }) ?
                    "Watched" : "Not watched"
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func removeFromWatched(_ sender: UIButton) {
        trakt.removeFromHistory(movies: [movie.ids.trakt]) { result in
            print(result)
        }
    }

    @IBAction func markWatched(_ sender: UIButton) {
        trakt.addToHistory(movies: [movie.ids.trakt]) { result in
            print(result)
        }
    }
}
