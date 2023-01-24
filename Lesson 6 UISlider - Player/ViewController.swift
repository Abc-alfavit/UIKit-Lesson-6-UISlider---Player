//
//  ViewController.swift
//  Lesson 6 UISlider - Player
//
//  Created by Валентин Ремизов on 20.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var vremenaImage: UIImageView!
    @IBOutlet weak var optimistImage: UIImageView!
    @IBOutlet weak var kaifImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

//MARK: - Присваиваем переменным следующего экрана значения в зависимости от выбранного трека + присваиваем трек + включаем его
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let player = segue.destination as? Window_player else {return}
//Для этого нужно сделать segue переход в Main с UIButton на следующий экран и идентификатору переходу задать имя
        if segue.identifier == "Vremena" {
            guard let img = vremenaImage.image else {return}
            player.image = img
            player.artistLabel.text = "Макс Корж"
            player.trackLabel.text = "Времена"
            player.indexSound = 0

            do {
                if let audioPath = Bundle.main.path(forResource: "Vremena", ofType: "mp3") {
                    try player.soundOutlet = AVAudioPlayer(contentsOf: URL(filePath: String(audioPath)))
                }
            } catch {
                print("Error")
            }
            player.soundOutlet.play()
        } else if segue.identifier == "Optimist" {
            guard let img = optimistImage.image else {return}
            player.image = img
            player.artistLabel.text = "Макс Корж"
            player.trackLabel.text = "Оптимист"
            player.indexSound = 1

            do {
                if let audioPath = Bundle.main.path(forResource: "Optimist", ofType: "mp3") {
                    try player.soundOutlet = AVAudioPlayer(contentsOf: URL(filePath: String(audioPath)))
                }
            } catch {
                print("Error")
            }
            player.soundOutlet.play()
        } else {
            guard let img = kaifImage.image else {return}
            player.image = img
            player.artistLabel.text = "Макс Корж"
            player.trackLabel.text = "Жить в кайф"
            player.indexSound = 2

            do {
                if let audioPath = Bundle.main.path(forResource: "Kaif", ofType: "mp3") {
                    try player.soundOutlet = AVAudioPlayer(contentsOf: URL(filePath: String(audioPath)))
                }
            } catch {
                print("Error")
            }
            player.soundOutlet.play()
        }
    }
}



