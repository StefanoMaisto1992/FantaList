//
//  Player.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation

struct Player: Codable {
    let playerId: Int // Id univoco del calciatore
    let playerName: String // Nome del calciatore
    let imageURL: String // URL immagine campioncino
    let teamAbbreviation: String // Nome abbreviato della squadra del calciatore
    let gamesPlayed: Int // Partite giocate
    let averageGrade: Double // Media voto
    let averageFantaGrade: Double // Media fantavoto
}
