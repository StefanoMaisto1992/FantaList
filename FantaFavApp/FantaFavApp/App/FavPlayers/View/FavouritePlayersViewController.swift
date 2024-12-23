//
//  FavouritePlayersViewController.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import UIKit
import Combine

struct PaletteColors {
    static let primary: UIColor = .systemBlue
    static let inactive: UIColor = .systemGray
}

struct ViewControllerConstants {
    static let cellHeight: CGFloat = 80
    static let playersViewController: String = "FavouritePlayersViewController"
}

class FavouritePlayersViewController: UIViewController, ViewModelBindable {

    private var viewModel: FavouritePlayersViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var searchCancellable: AnyCancellable?
    
    //UI elements
    @IBOutlet private weak var searchPlayersTextField: SearchTextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var playersListButton: UIButton!
    @IBOutlet private weak var playersIconImageView: UIImageView!
    @IBOutlet private weak var playersTabLabel: UILabel!
    @IBOutlet private weak var favouriteListButton: UIButton!
    @IBOutlet private weak var favIconImageView: UIImageView!
    @IBOutlet private weak var favTabLabel: UILabel!
    @IBOutlet private weak var favHeaderView: UIView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupTableView()
        bindViewModel()
    }
    
    init(viewModel: FavouritePlayersViewModel) {
        super.init(nibName: ViewControllerConstants.playersViewController, bundle: nil)
        self.viewModel = viewModel
        self.loadPlayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Setup UI
    private func setupUI() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func setupTableView() {
        tableView.register(.init(nibName: PlayerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PlayerTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTextField() {
        searchPlayersTextField.delegate = self
        setupTapGestureToDismissKeyboard()
    }
    
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // This ensures the tap gesture doesn't interfere with other gestures like table view taps
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        tableView.endEditing(true)
    }
    
    func bindViewModel() {
        listenTabChange()
        bindDataSource()
        bindingLoadingObservations()
    }
    
    private func listenTabChange() {
        viewModel.$mode
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newMode in
                guard let `self` else { return }
                self.updateUI(for: newMode)///Handle mode change
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindingLoadingObservations() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let `self` else { return }
                self.activityIndicator.isHidden = !isLoading
                isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let `self`, let errorMessage else { return }
                self.showError(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func bindDataSource() {
        viewModel.$players
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let `self` else { return }
                Task {
                    await self.viewModel.loadFavoritePlayers()
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$favoritePlayers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let `self`, viewModel.mode == .favouriteList else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Errore", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Configure UI for Favourite List Mode
    private func configureForFavouriteList() {
        playersIconImageView.tintColor = PaletteColors.inactive
        playersTabLabel.textColor = PaletteColors.inactive
        favIconImageView.tintColor = PaletteColors.primary
        favTabLabel.textColor = PaletteColors.primary
        favHeaderView.isHidden = false
        searchPlayersTextField.isHidden = true
    }
    
    // MARK: - Helper Method to Update UI Based on Mode
    private func updateUI(for mode: FavouritePlayersViewModel.TabMode) {
        switch mode {
        case .favouriteList:
            configureForFavouriteList()
        case .playersList:
            configureForPlayersList()
        }
    }

    // MARK: - Configure UI for Players List Mode
    private func configureForPlayersList() {
        favHeaderView.isHidden = true
        searchPlayersTextField.isHidden = false
        playersIconImageView.tintColor = PaletteColors.primary
        playersTabLabel.textColor = PaletteColors.primary
        favIconImageView.tintColor = PaletteColors.inactive
        favTabLabel.textColor = PaletteColors.inactive
    }
    
    private func loadPlayers() {
        Task {
            await viewModel.fetchPlayers(from: PlayersRepository.accessDataPoint)
        }
    }
    
    //ACTIONS
    @IBAction private func playersListTabAction(_ sender: UIButton) {
        viewModel.mode = .playersList
    }
    
    @IBAction private func favouriteListTabAction(_ sender: UIButton) {
        viewModel.mode = .favouriteList
    }
    
}
//MARK: - UITableViewDelegate
extension FavouritePlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewControllerConstants.cellHeight
    }
}
//MARK: - UITableViewDataSource
extension FavouritePlayersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isFiltered ? viewModel.searchResults.count : viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as? PlayerTableViewCell,
              indexPath.row < viewModel.dataSource.count else {
            return UITableViewCell()
        }
        let player = viewModel.dataSource[indexPath.row], isFavourite: Bool = viewModel.isFavorite(playerId: player.playerId)
        cell.delegate = self
        cell.fillCell(player: player, isFavMode: viewModel.mode == .favouriteList, isFavourite: isFavourite, indexPath: indexPath)
        return cell
    }
    
}
//MARK: - PlayerTableViewCellDelegate
extension FavouritePlayersViewController: PlayerTableViewCellDelegate {
    func favouriteSelectionDidTap(playerId: Int, at indexPath: IndexPath) {
        Task {
            await viewModel.isFavorite(playerId: playerId) ? viewModel.removeFromFavorites(playerId: playerId) : viewModel.addToFavorites(playerId: playerId)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}
//MARK: - UITextFieldDelegate
extension FavouritePlayersViewController: SearchTextViewDelegate {
    func textViewDidChange(text: String) {
        if text.count >= 3 {
            Task {
                await viewModel.searchPlayer(byName: text)
                viewModel.isFiltered = true
                tableView.reloadData() // Update the table view with filtered results
            }
        }
        else if viewModel.isFiltered && text.isEmpty {
            Task {
                await viewModel.resetSearch()
                viewModel.isFiltered =  false
                tableView.reloadData() // Reset to show all players
            }
        }
    }
}


