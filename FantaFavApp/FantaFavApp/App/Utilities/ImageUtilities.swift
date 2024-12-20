//
//  ImageUtilities.swift
//  BestFantaPlayers
//
//  Created by Stefano  Maisto on 20/12/24.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let url = URL(string: urlString) else {
            print("URL non valido: \(urlString)")
            return
        }
        
        // Controlla se l'immagine è già in cache
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Scarica l'immagine
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Errore nel download dell'immagine: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Impossibile creare l'immagine con i dati ricevuti.")
                return
            }
            
            // Memorizza l'immagine nella cache
            ImageCache.shared.setObject(image, forKey: urlString as NSString)
            
            // Aggiorna l'immagine sul thread principale
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        
        task.resume()
    }
}
