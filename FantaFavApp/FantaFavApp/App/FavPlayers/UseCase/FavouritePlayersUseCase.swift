//
//  FavouritePlayersUseCase.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation

protocol FavouritePlayersUseCaseProtocol {
    func fetchPlayers(from urlString: String) async throws
    func searchPlayer(byName: String) async -> [Player]
    func getFavouritePlayers() async -> [Player]
    func addToFavorites(playerId: Int) async
    func removeFromFavorites(playerId: Int) async
    func getPlayers() async -> [Player]
}

class FavouritePlayersUseCase: FavouritePlayersUseCaseProtocol {
    
    private let repository: PlayersRepository
    
    init(repository: PlayersRepository) {
        self.repository = repository
    }
    
    func fetchPlayers(from urlString: String) async throws {
        try await repository.fetchPlayers(from: urlString)
    }
    
    func searchPlayer(byName: String) async -> [Player] {
        await repository.searchPlayers(byName: byName)
    }
    
    func getFavouritePlayers() async -> [Player] {
        await repository.getFavoritePlayers()
    }
    
    func addToFavorites(playerId: Int) async {
        await repository.addToFavorites(playerId: playerId)
    }
    
    func removeFromFavorites(playerId: Int) async {
        await repository.removeFromFavorites(playerId: playerId)
    }
    
    func getPlayers() async -> [Player] {
        return await repository.getPlayers()
    }
    
}
