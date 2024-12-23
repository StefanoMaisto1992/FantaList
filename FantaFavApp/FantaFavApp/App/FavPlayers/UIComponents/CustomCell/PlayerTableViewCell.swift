//
//  PlayerTableViewCell.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import UIKit

protocol PlayerTableViewCellDelegate: AnyObject {
    func favouriteSelectionDidTap(playerId: Int, at indexPath: IndexPath)
}

class PlayerTableViewCell: UITableViewCell {
    
    static let identifier: String = "PlayerTableViewCell"

    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var clubNameLabel: UILabel!
    @IBOutlet private weak var pgValueLabel: UILabel!
    @IBOutlet private weak var mvValueLabel: UILabel!
    @IBOutlet private weak var mfvValueLabel: UILabel!
    @IBOutlet private weak var favButton: UIButton!
    
    private var isFavMode: Bool = false {
        willSet {
            self.hideElements(if: newValue)
        }
    }
    
    weak var delegate: PlayerTableViewCellDelegate?
    private var playerId: Int?, indexPath: IndexPath?
    private var isFavourite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        hideElements(if: false)///Deafults case
        updateFavouriteIcon()
        playerImageView.backgroundColor = .cyan.withAlphaComponent(0.5)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerImageView.layer.cornerRadius = playerImageView.bounds.size.width / 2
        playerImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction private func favTapAction(_ sender: UIButton) {
        if let playerId = playerId, let indexPath {
            delegate?.favouriteSelectionDidTap(playerId: playerId, at: indexPath)
            isFavourite.toggle()
            updateFavouriteIcon()
        }
    }
    
    public func fillCell(player: Player, isFavMode: Bool = false, isFavourite: Bool, indexPath: IndexPath) {
        playerImageView.setImage(from: player.imageURL)
        playerNameLabel.text = player.playerName
        clubNameLabel.text = player.teamAbbreviation
        pgValueLabel.text = "\(player.gamesPlayed)"
        mvValueLabel.text = String(format: "%.2f", player.averageGrade)
        mfvValueLabel.text = String(format: "%.2f", player.averageFantaGrade)
        // Salva l'ID del giocatore
        self.playerId = player.playerId
        self.indexPath = indexPath
        self.isFavMode = isFavMode
        favButton.setImage(UIImage(systemName: isFavourite ? "star.fill" : "star"), for: .normal)
    }
    
    private func hideElements(if isFavMode: Bool) {
        let favElementsList = [pgValueLabel, mvValueLabel, mfvValueLabel]
        favElementsList.forEach({$0?.isHidden = !isFavMode})
        favButton.isHidden = isFavMode
    }
    
    private func updateFavouriteIcon() {
        favButton.setImage(UIImage(systemName: isFavourite ? "star.fill" : "star"), for: .normal)
    }
    
}
