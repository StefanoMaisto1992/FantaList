//
//  SearchTextView.swift
//  FantaFavApp
//
//  Created by Stefano  Maisto on 23/12/24.
//

import UIKit

protocol SearchTextViewDelegate: AnyObject {
    func textViewDidChange(text: String)
}

class SearchTextView: UIView, UITextViewDelegate {
    
    weak var delegate: SearchTextViewDelegate?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass") // Icona lente
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Ricerca calciatore" // Placeholder
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    public let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.autocorrectionType = .no
        textView.textContainer.maximumNumberOfLines = 1 // Limita a una riga
        textView.textContainer.lineBreakMode = .byTruncatingTail // Truncamento del testo se necessario
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        textView.delegate = self
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(iconImageView)
        addSubview(textView)
        addSubview(placeholderLabel)
    }
    
    private func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Icona (lente)
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // TextView
            textView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textView.heightAnchor.constraint(equalToConstant: 40),
            
            // Placeholder
            placeholderLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            placeholderLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.textViewDidChange(text: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

