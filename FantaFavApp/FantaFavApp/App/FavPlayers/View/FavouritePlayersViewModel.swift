//
//  FavouritePlayersViewModel.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation

@MainActor
class FavouritePlayersViewModel: ObservableObject {
    
    enum TabMode {
        case playersList, favouriteList
    }
    
    @Published var players: [Player] = []        // Tutti i giocatori
    @Published var favoritePlayers: [Player] = [] // Giocatori preferiti
    @Published var searchResults: [Player] = []  // Risultati della ricerca
    @Published var isLoading: Bool = false       // Stato di caricamento
    @Published var errorMessage: String?
    
    @Published var mode: TabMode = .playersList // default case
    
    private let useCase: FavouritePlayersUseCaseProtocol
    
    init(useCase: FavouritePlayersUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // Metodo per scaricare i giocatori
    func fetchPlayers(from urlString: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await useCase.fetchPlayers(from: urlString)
            self.players = await useCase.getPlayers()
            isLoading = false
        } catch {
            errorMessage = "Impossibile caricare i giocatori: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    // Metodo per cercare un giocatore
    func searchPlayer(byName name: String) async {
        searchResults = await useCase.searchPlayer(byName: name)
    }
    
    // Metodo per ottenere i preferiti
    func loadFavoritePlayers() async {
        favoritePlayers = await useCase.getFavouritePlayers()
    }
    
    // Aggiungi un giocatore ai preferiti
    func addToFavorites(playerId: Int) async {
        await useCase.addToFavorites(playerId: playerId)
        await loadFavoritePlayers()
    }
    
    // Rimuovi un giocatore dai preferiti
    func removeFromFavorites(playerId: Int) async {
        await useCase.removeFromFavorites(playerId: playerId)
        removePlayer(with: playerId)
        await loadFavoritePlayers()
    }
    
    private func removePlayer(with playerId: Int) {
        for (i, player) in favoritePlayers.enumerated() {
            if player.playerId == playerId {
                favoritePlayers.remove(at: i)
                break
            }
        }
    }
    
    func resetSearch() async {
        self.players = await useCase.getPlayers()
    }
    
    func isFavorite(playerId: Int) -> Bool {
        return favoritePlayers.compactMap({$0.playerId}).contains(where: {$0 == playerId})
    }
    
}
