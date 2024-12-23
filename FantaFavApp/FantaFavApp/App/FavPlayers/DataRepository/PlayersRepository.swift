//
//  PlayersRepository.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation

extension PlayersRepository {
    typealias UserDefaultsKey = String
    static let favoritePlayerIdentifiers: UserDefaultsKey = "favoritePlayerIds"
    
    static func initializeFavoritesIfNeeded() {
        let userDefaults = UserDefaults.standard
        if userDefaults.array(forKey: favoritePlayerIdentifiers) as? [Int] == nil {
            userDefaults.set([], forKey: favoritePlayerIdentifiers)
        }
    }
}

actor PlayersRepository {
    private(set) var players: [Player] = []
    private (set) var favoritePlayerIds: Set<Int> = [] // ID dei calciatori preferiti
    private (set) var favoritePlayers: [Player] = []
    
    private let queue = DispatchQueue(label: "PlayersRepositoryQueue", attributes: .concurrent)
    
    func fetchPlayers(from urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let players = try decoder.decode([Player].self, from: data)
        
        self.players = players
        PlayersRepository.initializeFavoritesIfNeeded()
        self.loadFavoritePlayerIds()
    }
        
    func searchPlayers(byName name: String) -> [Player] {
        queue.sync {
            players.filter { $0.playerName.lowercased().contains(name.lowercased()) }
        }
    }
    
    func getPlayers() async -> [Player] {
        return players
    }
    
    func getFavoritePlayers() -> [Player] {
        queue.sync {
            loadFavoritePlayerIds()
            // Filtra i giocatori preferiti
            return favoritePlayers.sorted { player1, player2 -> Bool in // Sort dei giocatori preferiti
                if player1.teamAbbreviation == player2.teamAbbreviation {
                    return player1.playerName < player2.playerName
                } else {
                    return player1.teamAbbreviation < player2.teamAbbreviation
                }
            }
        }
    }
    
    func addToFavorites(playerId: Int) {
        addFavoritePlayerId(playerId)
        favoritePlayerIds.insert(playerId)
    }
    
    func removeFromFavorites(playerId: Int) {
        removeFavoritePlayerId(playerId)
        self.favoritePlayerIds.remove(playerId)
    }
    
    private func saveFavoritePlayerIds() {
        UserDefaults.standard.set(favoritePlayerIds, forKey: "favoritePlayerIds")
    }
    
    private func loadFavoritePlayerIds() {
        if let savedFavoritePlayerIds = UserDefaults.standard.array(forKey: PlayersRepository.favoritePlayerIdentifiers) as? [Int] {
            favoritePlayerIds = Set<Int>(savedFavoritePlayerIds)
            favoritePlayers = players.filter({ favoritePlayerIds.contains($0.playerId) })
        }
    }
    
    private func removeFavoritePlayerId(_ playerId: Int) {
        // Recupera l'array esistente da UserDefaults
        var favoritePlayerIds = UserDefaults.standard.array(forKey: PlayersRepository.favoritePlayerIdentifiers) as? [Int] ?? []
        favoritePlayerIds.removeAll { $0 == playerId }
        UserDefaults.standard.set(favoritePlayerIds, forKey: PlayersRepository.favoritePlayerIdentifiers)
    }
    
    func addFavoritePlayerId(_ playerId: Int) {
        var favoritePlayerIds = UserDefaults.standard.array(forKey: PlayersRepository.favoritePlayerIdentifiers) as? [Int] ?? []
        guard !favoritePlayerIds.contains(playerId) else { return }
        // Aggiungi il nuovo ID all'array
        favoritePlayerIds.append(playerId)
        // Aggiorna UserDefaults con l'array modificato
        UserDefaults.standard.set(favoritePlayerIds, forKey: PlayersRepository.favoritePlayerIdentifiers)
    }
    
}

