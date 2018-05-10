//
//  ViewController.swift
//  PokeBot
//
//  Created by Jacopo Mangiavacchi on 5/1/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit
import AudioToolbox
import Kingfisher

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    let baseURL = "https://pokebot.mybluemix.net/pokemon/any/"
    var pokemons = Pokemons()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 10.0
        layout.itemSize = CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSearch(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        searchTextField.text = ""
        headerLabel.text = "Enter the name of a Pokemon or Type"

        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.alpha = 0
            self.searchView.alpha = 1
        }, completion:  nil)

        searchTextField.keyboardAppearance = .dark //.default//.light//.alert
        
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pokemons = Pokemons()
        collectionView.reloadData()

        if let text = searchTextField.text {
            searchNewPokemon(searchText: text)
        }
        
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.alpha = 1
            self.searchView.alpha = 0
        }, completion:  nil)

        return true
    }
    
    func searchNewPokemon(searchText: String) {
        if let url = URL(string: baseURL + searchText) {
            headerLabel.text = "Searching..."
            loadingActivityIndicator.startAnimating()
            let task = URLSession.shared.pokemonsTask(with: url) { pokemons, response, error in
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
                    if let pokemons = pokemons {
                        self.headerLabel.text = "Found \(pokemons.count) Pokemons"
                        self.pokemons = pokemons
                        self.collectionView.reloadData()
                    }
                    else {
                        self.headerLabel.text = "Found no Pokemons"
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        
        let pokemon = pokemons[indexPath.row]
        
        let url = URL(string: pokemon.image)
        cell.imageView.kf.setImage(with: url)
        cell.nameLabel.text = pokemon.name
        cell.typeLabel.text = pokemon.types.reduce("") { $0 + " " + $1 }
        cell.heightLabel.text = String(format: "Height: %d cm", pokemon.height)
        cell.weightLabel.text = String(format: "Width: %d cm", pokemon.weight)
        cell.habitatLabel.text = "Lives in \(pokemon.habitats)"
        cell.flavorTextLabel.text = pokemon.flavorText
        
        return cell
    }

}

