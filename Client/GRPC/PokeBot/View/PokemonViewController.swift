//
//  PokemonViewController.swift
//  PokeBot
//
//  Created by Jacopo Mangiavacchi on 5/1/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import UIKit
import AudioToolbox
import Kingfisher


class PokemonViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var datasource = PokemonDataSource()

    let cellScalingWidth: CGFloat = 0.8
    let cellScalingHeight: CGFloat = 1.15

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWidth = floor(contentView.bounds.width * cellScalingWidth)
        let cellHeight = floor(contentView.bounds.height * cellScalingHeight)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
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
        datasource.reset()
        collectionView.reloadData()

        if let text = searchTextField.text {
            headerLabel.text = "Searching..."
            loadingActivityIndicator.startAnimating()

            datasource.searchNewPokemon(searchText: text) {
                self.loadingActivityIndicator.stopAnimating()
                self.headerLabel.text = "Found \(self.datasource.pokemons.count) Pokemons"
                self.collectionView.reloadData()
            }
        }
        
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.alpha = 1
            self.searchView.alpha = 0
        }, completion:  nil)

        return true
    }
}


extension PokemonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        
        let pokemon = datasource.pokemons[indexPath.row]
        
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

extension PokemonViewController : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension PokemonViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.pokemons.count
    }
}


