//
//  PlayersRepository.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation

actor PlayersRepository {
    private(set) var players: [Player] = []
    private var favoritePlayerIds: Set<Int> = [] // ID dei calciatori preferiti
    
    private let queue = DispatchQueue(label: "PlayersRepositoryQueue", attributes: .concurrent)
    
    func fetchPlayers(from urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let players = try decoder.decode([Player].self, from: data)
        
        self.players = players
    }
        
    func searchPlayers(byName name: String) -> [Player] {
        queue.sync {
            players.filter { $0.playerName.lowercased().contains(name.lowercased()) }
        }
    }
    
    func getPlayers()async -> [Player] {
        return players
    }
    
    func getFavoritePlayers() -> [Player] {
        queue.sync {
            players.filter { favoritePlayerIds.contains($0.playerId) }
        }
    }
    
    func addToFavorites(playerId: Int) {
        self.favoritePlayerIds.insert(playerId)
    }
    
    func removeFromFavorites(playerId: Int) {
        self.favoritePlayerIds.remove(playerId)
    }
}

